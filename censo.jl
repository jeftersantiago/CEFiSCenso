using CSV, DataFrames
using Printf, Plots
using StatsBase
using StatsPlots
# deixar isso dinamico também, permitir passar o nome do arquivo em uma função
global data=0;
global option=0;
# lista com as perguntas
global question=0;

function setFile(path,isData, removeAt)
    if isData
        global data = CSV.read(string(dataFile), DataFrame)
        ## removendo as colunas data, nome e nº usp
        select!(data, Not(1:removeAt))
    else
       global  option = CSV.read(string(optionsFile), DataFrame)
       select!(option, Not(1:removeAt))
       global  question = getindex(names(option), 1:length(names(option)))
    end
end
function genGraph(question, x , options, ans,fileName)
   bar!(ans,alpha=1,xrotation=0,label="", xticks=(1:1:length(options),options),color="red",subplot=1)

    plot!(title=question,titlefont=font(6,"Noto Sans Mono"))
    plot!(ylabel="Número de respostas",titlefont=font(8,"Noto Sans Mono"))

    closeall()

    figName = string("./graficos/", fileName, ".pdf");
    savefig(figName);
end

# Percorre a lista de alternativa e remove os indices missing
# Retorna a lista de opções, a partir da lista é possivel chamar a função
# de gráfico e etc.
function alternatives(opt)
    i = 1;
    n = length(opt) -  length(findall(ismissing,opt));
    # declarei dessa forma e no final do loop removo o primeiro valor usando
    # a função popfirst
    list = [""]
    while i in 1:length(opt)
        if !isequal(opt[i],missing)
            # usa o push aqui pq não quero ter que lidar com o indice em cada array
            push!(list, string(opt[i]));
       end
            i+=1;
    end
    popfirst!(list);
    return reverse(list,1,length(list));
end
# Retorna uma lista com os valores (número de escolhas) para cada opção
function setData(dataList,optList)
    list = Array{Int64,1}(undef,length(optList));
    i=1;
    while i in 1:length(optList)
        list[i] = 0;
        x=1;
        while x in 1:length(dataList)
            println("Aqui")
            if isequal(string(optList[i]), string(dataList[x]))
                println("\n =============== aqui ============== \n")
                list[i]+=1;
            end
            x+=1;
        end
        i+=1;
    end
    return list;
end

function genGraph(question, x , options, ans,fileName)
    bar(ans,alpha=1,xrotation=0,label="", xticks=(1:1:length(options),options),color="red",subplot=1)

    plot!(title=question,titlefont=font(6,"Noto Sans Mono"))
    plot!(ylabel="Número de respostas",titlefont=font(8,"Noto Sans Mono"))

    closeall()

    figName = string("./graficos/", fileName, ".pdf");
    savefig(figName);
end

function run(n)
   global opt = alternatives(option[!,question[n]]);
   global ans = data[!,n];
   global out = setData(ans,opt);
    fileName = string("pergunta",string(n));
    genGraph(question[n], out, opt, out, fileName );
end








