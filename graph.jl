using Printf, Plots
using StatsPlots
# Gera um gráfico em barra com as opções
# TODO Store images in the barGraph() function.
function barGraph(questTitle, x , options, ans )
y = ans; 
Plots.bar(x,y, title=questTitle,xticks=(1:length(x), options), legend=false,grid=false)
end


# Exemplo de uso 
#option = ["Muito Insatisfeito", "Insatisfeito", "Pouco Insatisfeito", "Satisfeito", "Muito Satisfeito"]
#ans = [34,44,54,43,13];
# barGraph("Pergunta",[1,2,3,4,5], option, ans)
#                    [1:5] não funcionou :o 

