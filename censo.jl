include("genCharts.jl")

using CSV, DataFrames

global data=0;
global option=0;
global opt=0;

# lista com as perguntas
global question=0;

function setFile(path::String,isData::Bool, removeAt::Int64)
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

# Removes 'missing' elements and returns the options list.
function alternatives(opt::AbstractArray)
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
function setData(dataList::AbstractArray,optList::AbstractArray)::AbstractArray
    list = Array{Int64,1}(undef,length(optList));
    i=1;
    while i in 1:length(optList)
        list[i] = 0;
        j=1;
        while j in 1:length(dataList)
            if isequal(string(optList[i]), string(dataList[j]))
                list[i]+=1;
            end
            j+=1;
        end
        i+=1;
    end
    return list;
end

function runForIndex(n::Int64)
   global opt = alternatives(option[!,question[n]]);
   global ans = data[!,n];
   global out = setData(ans,opt);
   fileName = string("./Graficos/Grafico - ",string(n), ".pdf");
   barChart(question[n],out,opt,fileName)
end

function runForAll(dataFile,optionsFile, removeColumnsUpTo)

    setFile(dataFile, true, removeColumnsUpTo);
    setFile(optionsFile,false,removeColumnsUpTo);

    i=1;
    while i in 1:length(names(data))
        println("Gerando arquivo nº ", i);
        runForIndex(i);
        i+=1;
    end
end
