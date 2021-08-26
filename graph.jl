using Printf, Plots
using StatsPlots
# Gera um gráfico em barra com as opções
function barGraph(questTitle, x , options, ans )
y = ans; 
Plots.bar(x,y, title=questTitle,xticks=(1:length(x), options), legend=false,grid=false)
end

