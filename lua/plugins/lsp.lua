local function filter(arr, fn)
  if type(arr) ~= "table" then
    return arr
  end

  local filtered = {}
  for k, v in pairs(arr) do
    if fn(v, k, arr) then
      table.insert(filtered, v)
    end
  end

  return filtered
end

local function filterReactDTS(value)
  return string.match(value.targetUri, 'react/index.d.ts') == nil
end


return {
    'neovim/nvim-lspconfig',
    init = function()
        lspconfig = require("lspconfig")
        lspconfig.tsserver.setup {
          handlers = {
            ['textDocument/definition'] = function(err, result, method, ...)
              if vim.tbl_islist(result) and #result > 1 then
                local filtered_result = filter(result, filterReactDTS)
                return vim.lsp.handlers['textDocument/definition'](err, filtered_result, method, ...)
              end

              vim.lsp.handlers['textDocument/definition'](err, result, method, ...)
            end
          }
            }
        lspconfig.gopls.setup {}

        vim.keymap.set('n', '<leader>vd', vim.diagnostic.open_float)
    end,
}
