local Consumer = {}
local root = nil

function Consumer:SetRoot(value)
  root = value
end

function Consumer:Handle(slot)
  if root == nil or type(root.HandleParchmentControl) ~= "function" then
    return false
  end
  return root:HandleParchmentControl(slot)
end

return Consumer
