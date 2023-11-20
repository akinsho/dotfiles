return {
  'tpope/vim-projectionist',
  lazy = false,
  init = function()
    vim.g.projectionist_heuristics = {
      ['*.go'] = {
        ['*.go'] = {
          alternate = '{}_test.go',
          type = 'source',
          template = {
            'package {basename|camelcase}',
          },
        },
        ['*_test.go'] = {
          alternate = '{}.go',
          type = 'test',
          template = {
            'package {basename|camelcase}',
          },
        },
      },
      ['src/'] = {
        ['*.ts'] = {
          alternate = '{}.test.ts',
          type = 'source',
        },
        ['*.test.ts'] = {
          alternate = '{}.ts',
          type = 'test',
          template = {
            "import {basename|camelcase|capitalize} from '@/{dirname}/{basename}';",
            '',
            "describe('{basename|camelcase|capitalize}', () => {open}",
            "  it('works', () => {open}",
            '    expect(true).toBe(true);',
            '   {close});',
            '{close});',
          },
        },
        ['*.tsx'] = {
          alternate = '{}.test.tsx',
          type = 'source',
          template = {
            "import type React, {open} FC {close} from 'react';",
            '',
            'type {basename|camelcase|capitalize}Props = {open}',
            '  property?: unknown;',
            '{close};',
            '',
            'const {basename|camelcase|capitalize}: FC<{basename|camelcase|capitalize}Props> = _props => {',
            '  return <div>{basename|camelcase|capitalize}</div>;',
            '};',
            '',
            'export default {basename|camelcase|capitalize};',
          },
        },
        ['*.test.tsx'] = {
          alternate = '{}.tsx',
          type = 'test',
          template = {
            "import {open} render {close} from '@/test-utils';",
            "import {basename|camelcase|capitalize} from '@/{dirname}/{basename}';",
            '',
            "describe('{basename|camelcase|capitalize}', () => {open}",
            "  it('matches snapshot', () => {open}",
            '    const {open} asFragment {close} = render(<{basename|camelcase|capitalize} />, {open}{close});',
            '    expect(asFragment()).toMatchSnapshot();',
            '   {close});',
            '{close});',
          },
        },
      },
      ['src/routes/*'] = {
        ['*.svelte'] = {
          alternate = { '{}.server.ts', '{}.ts' },
          type = 'view',
        },
        ['*.server.ts'] = {
          alternate = { '{}.svelte', '{}.ts' },
          type = 'server',
          template = {
            "import type { PageServerLoad } from './$types';",
            "import { redirect } from '@sveltejs/kit';",
            '',
            'export const load: PageServerLoad = async ({ url, locals: { getSession } }) => {',
            'const session = await getSession();',
            "// TODO: hard part's done",
            '};',
          },
        },
        ['*.ts'] = {
          alternate = { '{}.svelte' },
          type = 'client',
        },
      },
      ['lib/*.dart'] = {
        ['lib/screens/*.dart'] = {
          alternate = 'lib/view_models/{}_view_model.dart',
          type = 'view',
        },
        ['lib/view_models/*_view_model.dart'] = {
          alternate = { 'lib/screens/{}.dart', 'lib/widgets/{}.dart' },
          type = 'model',
          template = { 'class {camelcase|capitalize}ViewModel extends BaseViewModel {', '}' },
        },
        ['test/view_models/*_view_model_test.dart'] = {
          alternate = 'lib/view_models/{}_view_model.dart',
          type = 'test',
          template = {
            "import 'package:test/test.dart';",
            '',
            'void main() async {',
            "  group('TODO', () {",
            '    // TODO:',
            '  })',
            '}',
          },
        },
        ['test/services/*_test.dart'] = {
          alternate = 'lib/services/{}.dart',
          type = 'test',
          template = {
            "import 'package:test/test.dart';",
            '',
            'void main() async {',
            "  group('TODO', () {",
            '    // TODO:',
            '  })',
            '}',
          },
        },
        ['test/widget/*_test.dart'] = {
          alternate = 'lib/screens/{}.dart',
          type = 'test',
          template = {
            "import 'package:test/test.dart';",
            '',
            'void main() async {',
            "  group('TODO', () {",
            '    // TODO:',
            '  })',
            '}',
          },
        },
      },
    }
  end,
  keys = {
    { '<leader>A', '<Cmd>A<CR>', desc = 'projectionist: edit alternate' },
    { '<leader>av', '<Cmd>AV<CR>', desc = 'projectionist: vsplit alternate' },
    { '<leader>at', '<Cmd>AT<CR>', desc = 'projectionist: vsplit test' },
  },
}
