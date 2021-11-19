using Plots
using StatsPlots, StatsBase
using LaTeXStrings
using TextWrap

# qt = titulo do gráfico
# ans = dados, lista de valores de cada respostas
# fileName = nome que o arquivo .pdf vai ter
# opt = as opções de respostas, isso fica como legenda e tals

# Generates a bar chart.
function barChart(qt,ans,opt,fileName)
    # Colour palette
    # see https://docs.juliaplots.org/latest/generated/colorschemes/
    palette = cgrad(:glasbey_category10_n256)#:Set3_12);
    cs=rand(1:100, 10);
    colours = [palette[i] for i in cs];

    legend = opt[:,:];
    legend = reshape(legend,(1,length(legend)));
    
    bar((1:length(opt))', ans', title=TextWrap.wrap(qt, width=70),color= colours', label=legend);

    #default
    fontsize=8;
   
    plot!(ylabel=L"n° de respostas",legend=:outerright, xaxis=nothing, titlefont=font(fontsize,"serif"));

    fileName= string("./Graficos/Barra/",fileName);

    closeall();  
    savefig(fileName);
end
