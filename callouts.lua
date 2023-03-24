-- source: https://github.com/quarto-dev/quarto-cli/discussions/2869
-- modification: only callapse callout-tip by default

function Div(el)
  if quarto.doc.isFormat("html") then
    callouts = {'callout-tip'}
    for key, val in pairs(callouts) do
      if el.classes:includes(val) then
        el.attributes["collapse"] = 'true'
        return el
      end
    end
  end
end 
