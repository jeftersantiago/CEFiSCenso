using Printf, Plots
using StatsBase
using StatsPlots
function barGraph(question, x , options, ans,fileName)
   bar!(ans,alpha=1,xrotation=0,label="", xticks=(1:1:length(options),options),color="red",subplot=1)

    plot!(title=question,titlefont=font(6,"Noto Sans Mono"))
    plot!(ylabel="Número de respostas",titlefont=font(8,"Noto Sans Mono"))

   # closeall()

    figName = string("./graficos/", fileName, ".pdf");
    savefig(figName);
end


