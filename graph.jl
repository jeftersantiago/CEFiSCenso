using Printf, Plots
using StatsBase
using Statistics
using StatsPlots
using LaTeXStrings
# TODO Store images in the barGraph() function.
function barGraph(question, x , options, ans )
#Plots.bar(x,y, title=question,xticks=([1,2,3,4,5], options), legend=false,grid=false)
    bar!(ans,alpha=1.5,xrotation=50,label="", xticks=(1:1:length(options),options),color="red",subplot=1)
    plot!(title=question,titlefont=font(10,"Noto Sans Mono"))
    plot!(ylabel="Número de respostas",titlefont=font(10,"Noto Sans Mono"))
    y = collect(0.01:.01:1.0)
    ticks = collect(0.0:0.1:1.0)
#   yticks!([0:Statistics.mean(ans):maximum(ans);],) 
    savefig("./plot.pdf")
end


