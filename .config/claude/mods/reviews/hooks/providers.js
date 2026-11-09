export const GITHUB_QUERY = `
fragment pr on PullRequest {
  number title url updatedAt isDraft reviewDecision
  repository { nameWithOwner }
  latestReviews(first: 10) { nodes { state author { login } } }
}
query {
  mine: search(query: "is:pr is:open archived:false author:@me", type: ISSUE, first: 30) { nodes { ...pr } }
  waiting: search(query: "is:pr is:open archived:false review-requested:@me", type: ISSUE, first: 30) { nodes { ...pr } }
}`;
export function ago(iso, now) {
    const minutes = Math.max(0, Math.round((now - Date.parse(iso)) / 60000));
    if (minutes < 60)
        return `${minutes}m`;
    const hours = Math.round(minutes / 60);
    if (hours < 48)
        return `${hours}h`;
    return `${Math.round(hours / 24)}d`;
}
function fromGithub(pr, now) {
    return {
        id: `#${pr.number}`,
        title: pr.title,
        repo: pr.repository.nameWithOwner,
        url: pr.url,
        status: pr.isDraft
            ? 'DRAFT'
            : (pr.reviewDecision ?? 'OPEN').replace('REVIEW_REQUIRED', 'OPEN'),
        approvedBy: pr.latestReviews.nodes
            .filter(review => review.state === 'APPROVED' && review.author)
            .map(review => review.author.login),
        updated: ago(pr.updatedAt, now),
    };
}
export function parseGithub(stdout, now) {
    const { data } = JSON.parse(stdout);
    const list = (nodes) => nodes.filter(node => node && node.url).map(node => fromGithub(node, now));
    return { mine: list(data.mine.nodes), waiting: list(data.waiting.nodes) };
}
// The CRUX dashboards come back as a markdown table whose cells are reference
// links (`[CR-123][1]`) with markdown-escaped text.
function linkText(cell) {
    const match = cell.trim().match(/^\[(.*)\]\[\d+\]$/);
    return (match?.[1] ?? cell).replace(/\\(.)/g, '$1').trim();
}
function fromCruxRow(row) {
    const id = linkText(row['ID'] ?? '');
    const summary = linkText(row['Summary'] ?? '');
    const scope = summary.match(/^\[([^\]]+)\]\s*(.*)$/);
    return {
        id,
        title: scope?.[2] ?? summary,
        repo: scope?.[1] ?? '',
        url: `https://code.amazon.com/reviews/${id}`,
        status: (row['Status'] ?? '').trim(),
        approvedBy: (row['Approved by'] ?? '')
            .split(/[\s,]+/)
            .filter(word => /^[a-z0-9-]+$/i.test(word)),
        updated: (row['Last touched'] ?? '').match(/^(.*?ago)/)?.[1] ?? '',
    };
}
export function parseCruxTable(markdown) {
    const lines = markdown.split('\n').filter(line => line.startsWith('|'));
    if (lines.length < 2)
        return [];
    const cells = (line) => line.slice(1, -1).split(/(?<!\\)\|/);
    const header = cells(lines[0] ?? '').map(cell => cell.trim());
    return lines
        .slice(2)
        .map(line => Object.fromEntries(cells(line).map((cell, i) => [header[i], cell])))
        .map(fromCruxRow)
        .filter(review => review.id.startsWith('CR-'));
}
// builder-mcp answers each input as its own JSON object, sometimes several in
// one text block, each holding the page's markdown under `content.content`, or
// `content.error` when the page could not be read.
export function cruxPages(text) {
    const pages = [];
    for (const chunk of text.split(/(?<=\})(?=\{"content")/)) {
        let parsed;
        try {
            parsed = JSON.parse(chunk);
        }
        catch {
            pages.push(chunk);
            continue;
        }
        if (parsed?.content?.error)
            throw new Error(parsed.content.error);
        pages.push(parsed?.content?.content ?? chunk);
    }
    return pages;
}
