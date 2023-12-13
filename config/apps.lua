local _M = {}

_M.terminal   = os.getenv('TERMINAL') or 'kitty'
_M.editor     = os.getenv('EDITOR')   or 'code'
_M.browser    = os.getenv('BROWSER')  or 'brave-browser'
_M.file_explorer = 'nautilus'

_M.editor_cmd = _M.editor
_M.manual_cmd = _M.terminal .. ' -e man awesome'

return _M