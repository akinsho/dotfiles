import { atom, read, update } from 'claude-code';
import { cruxPages, GITHUB_QUERY, parseCruxTable, parseGithub } from './providers';
const PANE = 'reviews';
const COLUMNS = 48;
const LOOK = { title: 'Reviews', backgroundColor: 'transparent' };
// Each review takes four lines, each section a header of three and a gap, and
// the frame two; the first section's header has no rule above it, the frame's
// top edge standing in for it.
function height(lists) {
    const sections = [lists.waiting, lists.mine].filter(list => list.length > 0);
    return sections.reduce((rows, list) => rows + 4 + list.length * 4, 2);
}
const reviews = atom({ plugin: 'reviews', key: 'reviews' }, null, {
    shape: 'reviews-1',
});
let source;
let isFetching = false;
let failures = 0;
let pending;
// After a failed fetch the next one waits twice as long as the last, and after
// MAX_FAILURES in a row the pane stops fetching until a refresh by hand.
const MAX_FAILURES = 5;
const TOASTED = 'toasted';
async function onPath($, command) {
    const ran = await $.process
        .run(['sh', '-c', `command -v ${command}`])
        .catch(() => undefined);
    return ran?.exitCode === 0;
}
async function pick($, provider) {
    if (provider === 'github' || provider === 'crux')
        return provider;
    if (provider !== 'auto')
        return undefined;
    if (await onPath($, 'cr'))
        return 'crux';
    if (await onPath($, 'gh'))
        return 'github';
    return undefined;
}
async function fetchGithub($) {
    const ran = await $.process.run(['gh', 'api', 'graphql', '-f', `query=${GITHUB_QUERY}`]);
    if (ran.exitCode !== 0)
        throw new Error(ran.stderr.trim() || 'gh failed');
    return parseGithub(ran.stdout, await $.clock.now());
}
async function fetchCrux($, user) {
    const base = 'https://code.amazon.com/reviews';
    const result = await $.mcp.call('builder-mcp', 'ReadInternalWebsites', {
        inputs: [`${base}/from-user/${user}`, `${base}/to-user/${user}`],
    });
    const text = result.content
        .map(block => ('text' in block && typeof block.text === 'string' ? block.text : ''))
        .join('');
    if (result.isError)
        throw new Error(text.slice(0, 200) || 'builder-mcp failed');
    const [mine = '', waiting = ''] = cruxPages(text);
    return { mine: parseCruxTable(mine), waiting: parseCruxTable(waiting) };
}
// Every session shows the counts; the pane opens only on /reviews or the
// band's button. The store is shared by all sessions, so a review that starts
// waiting on the person is toasted once rather than once per session.
async function announce($, lists) {
    const waiting = lists.waiting.length;
    const mine = lists.mine.length;
    const parts = [waiting > 0 && `${waiting} waiting on you`, mine > 0 && `${mine} yours`].filter(Boolean);
    $.ui.status(parts.length > 0 ? `reviews: ${parts.join(' · ')}` : undefined);
    if (waiting + mine === 0)
        await $.ui.close({ id: PANE });
    const ids = lists.waiting.map(review => review.id);
    const toasted = new Set((await $.store.get(TOASTED)));
    const fresh = lists.waiting.filter(review => !toasted.has(review.id));
    if (fresh.length > 0) {
        $.ui.toast(fresh.length === 1 ? `Review waiting on you: ${fresh[0].title}` : `${fresh.length} new reviews waiting on you`);
    }
    await $.store.set(TOASTED, ids);
}
function openPane($, lists) {
    return $.ui.open({ id: PANE, ...LOOK, focus: true, rows: height(lists), columns: COLUMNS });
}
function schedule($, settings, ms) {
    pending?.cancel();
    pending = $.clock.after(ms, () => void refresh($, settings));
}
async function refresh($, settings) {
    if (isFetching || !source)
        return;
    isFetching = true;
    pending?.cancel();
    pending = undefined;
    try {
        const user = settings.user || (await $.env.get('USER')) || '';
        const lists = source === 'crux' ? await fetchCrux($, user) : await fetchGithub($);
        const fetchedAt = await $.clock.now();
        await update($, reviews, () => ({ ...lists, fetchedAt }));
        await announce($, lists);
        failures = 0;
        schedule($, settings, settings.intervalMs);
    }
    catch (error) {
        const message = error instanceof Error ? error.message : String(error);
        const fetchedAt = await $.clock.now();
        failures += 1;
        const isPaused = failures >= MAX_FAILURES;
        await update($, reviews, last => ({
            mine: last?.mine ?? [],
            waiting: last?.waiting ?? [],
            fetchedAt,
            error: message.split('\n')[0],
            isPaused,
        }));
        if (!isPaused)
            schedule($, settings, settings.intervalMs * 2 ** failures);
    }
    finally {
        isFetching = false;
    }
}
// A refresh by hand starts the backoff over.
function refreshNow($, settings) {
    failures = 0;
    return refresh($, settings);
}
async function openUrl($, url) {
    const ran = await $.process.run(['open', url]).catch(() => undefined);
    if (ran?.exitCode !== 0)
        await $.process.run(['xdg-open', url]);
}
export const register = (on, options) => {
    const minutes = Math.max(1, Number(options.refreshMinutes ?? 5));
    const settings = {
        provider: String(options.provider ?? 'auto'),
        user: String(options.user ?? ''),
        intervalMs: minutes * 60000,
    };
    on('session.start', async ($, e, next) => {
        const started = await next(e);
        source = await pick($, settings.provider);
        if (!source)
            return started;
        await $.command.register({
            name: 'reviews',
            description: 'Show your open reviews and the ones waiting on you',
        });
        void refreshNow($, settings);
        return started;
    });
    on('command.run', { command: 'reviews' }, async ($) => {
        await refreshNow($, settings);
        const state = await read($, reviews);
        if (state?.error)
            return { text: `Could not read ${source} reviews: ${state.error}` };
        if (!state || state.mine.length + state.waiting.length === 0) {
            return { text: 'No open reviews, and none waiting on you.' };
        }
        await openPane($, state);
        return { text: 'Reviews pane opened.' };
    });
    on('ui.render', { component: 'AbovePrompt' }, async ($, e, next) => {
        const state = await read($, reviews);
        const waiting = state?.waiting ?? [];
        if (e.props.hasSurvey || !state || waiting.length === 0)
            return next(e);
        const { Box, Button, Text } = $.ui.resolve(e);
        const [first] = waiting;
        return (<Box gap={1}>
        <Text bold color="warning">
          ● {waiting.length === 1 ? '1 review' : `${waiting.length} reviews`} waiting on you
        </Text>
        {waiting.length === 1 && first && (<Text wrap="truncate-end">{first.title}</Text>)}
        <Button key="open" label="open" dimColor onPress={() => void openPane($, state)}/>
      </Box>);
    });
    on('ui.render', { component: 'Pane', requestId: PANE }, async ($, e) => {
        const { Box, Button, Text } = $.ui.resolve(e);
        const state = await read($, reviews);
        const row = (review) => (<Box key={review.id} flexDirection="column">
        <Button key={`open-${review.id}`} plain onPress={() => void openUrl($, review.url)}>
          <Text bold underline wrap="truncate-end">
            {review.title}
          </Text>
        </Button>
        <Text dimColor wrap="wrap">
          {review.id} {review.repo ? `· ${review.repo} ` : ''}· {review.status}
          {review.approvedBy.length > 0 ? ` · ✓ ${review.approvedBy.join(', ')}` : ''}
          {review.updated ? ` · ${review.updated}` : ''}
        </Text>
        <Box marginBottom={1}>
          <Button key={`ask-${review.id}`} label="address" dimColor onPress={() => void $.prompt.fill({
                text: `Address the open review comments on ${review.url}`,
                mode: 'replace',
            })}/>
        </Box>
      </Box>);
        const waiting = state?.waiting ?? [];
        const mine = state?.mine ?? [];
        const rule = '─'.repeat(Math.max(8, e.props.bodyColumns - 4));
        const section = (title, list, isFirst) => list.length > 0 && (<Box flexDirection="column" marginBottom={1}>
          {!isFirst && <Text color="claude">{rule}</Text>}
          <Text bold color="claude">
            {title.toUpperCase()} <Text dimColor>{list.length}</Text>
          </Text>
          <Text color="claude">{rule}</Text>
          {list.map(row)}
        </Box>);
        return (<Box flexDirection="column" borderStyle="single" borderColor="subtle" paddingX={1}>
        {state?.error && (<Text dimColor wrap="truncate-end">
            {state.isPaused ? 'Stopped refreshing' : 'Last refresh failed'}: {state.error}
          </Text>)}
        {section('Waiting on you', waiting, true)}
        {section('Yours', mine, waiting.length === 0)}
        <Button key="refresh" label="refresh" hotkey="r" dimColor onPress={() => void refreshNow($, settings)}/>
      </Box>);
    });
};
