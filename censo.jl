using CSV, DataFrames
using Plots
using StatsBase
using StatsPlots
# deixar isso dinamico também, permitir passar o nome do arquivo em uma função
global data=0;
global option=0;
global opt=0;
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

# Percorre a lista de alternativa e remove os indices missing
# Retorna a lista de opções, a partir da lista é possivel chamar a função
# de gráfico e etc.
# TODO: colocar o tipo de opt
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
            if isequal(string(optList[i]), string(dataList[x]))
                list[i]+=1;
            end
            x+=1;
        end
        i+=1;
    end
    return list;
end


function relateTables(l)
#    if isequal(string(optList[i]), string(dataList[x]))
#        list[i]+=1;
#    if isequal(string(opt[i])), string(data[i,1])

   k=1; # to run for all elements of the data
   while k in 1:size(data,2)
       i=1;# controls index of alternatives for each question
       # When it leaves this loop all graphs for 1 of the choosen
       # option will be ready to be transform into graph
       global opt = alternatives(option[!,question[k]]);
       list = Array{Int64,1}(undef,length(opt));

       while i in 1:length(opt)
           j=1; # run through all answers for the question in the data
           while j in 1:size(data,1)
#               if isequal(string(opt[i]),string(data[j,1]))
                   # create a list in which will run to generate the graphs
#                   list[i]+=1;
#               end
#               print("\n lista[i] = ", list[i]);
               j+=1;
#               print("\n", show(list));
           end
           i+=1;
           print("\n List  =  ",length(list))
       end
       # generate the graphs here
       # TODO: change function to accept a title
       # function graph(title)
       # graph(string(opt[i]))
#       title= string(question[k])
#       fileName = string("Gráfico - ",string(k));
#       genGraph(title,list,opt,fileName);
       k+=1;
   end
end


# 1° - listar n° respostas pra cada disciplina.
# 2° - da lista de opções de disciplinas rodar o loop
#  por exemplo: disciplina 1: algebra linear
#  roda loop pegando valor total de pessoas que responderam algelin
#  roda loop pegando respostas da pergunta x pra quem respondeu algelin
function relateTables()
    n = 1;
   global ans = data[!,n];
   global opt = alternatives(option[!,question[n]]);
#   global out = setData(ans,opt);
#   fileName = string("Grafico - ",string(n));
#   genGraph(question[n],out,opt,fileName)

    list = Array{Int64,1}(undef,length(opt));
    i=1;
    while i in 1:length(opt)
        list[i] = 0;
        x=1;
        
        while x in 1:size(data,1)
#            fileName="teoricas",i;
#            figName = string("./Graficos/", fileName,".pdf");
#            if isequal(string(opt[i]), string(data[x]))
            # se entrar  aqui fazer uma lista com todas respostas seguintes
            # para cada vez que entrar adicionar à lista

            # Ex: entrou em intro a fiscomp -> cata todas respostas todas vezes que entrar aqui
            # No final rodar o setData-> genGraph a partir desses valores novos

#                list[i]+=1;
#                print("list[i] = " ,list[i]);
#            end
            x+=1;
        end
        i+=1;
    end
end

# Gera o gráfico - em barras por enquanto
# question = titulo do gráfico
# answers = dados, lista de valores de cada respostas
# options = as opções de respostas, isso fica como legenda e tals
# fileName = nome que o arquivo .pdf vai ter
function genGraph(question,answers,options,fileName)

    palette = cgrad(:Set3_12);#  cgrad(:BrBG_10);
    cs=rand(1:10, 10);
    
   
    #bar(answers,alpha=1,xrotation=0,label="",xticks=(1:1:length(options),options), color=color=[palette[i] for i in cs], legend=:topleft, subplot=1)
    bar((1:length(options))', answers', color= [palette[i] for i in cs]')#, label=[string(options[i]) for i in ])

    plot!(ylabel="Respostas",titlefont=font(8,"Roboto Regular"))

    closeall()
    figName = string("./Graficos/", fileName,".pdf");
    savefig(figName);
end


# TODO: colocar o tipo de n
function runForIndex(n)
   global opt = alternatives(option[!,question[n]]);
   global ans = data[!,n];
   global out = setData(ans,opt);
   fileName = string("Grafico - ",string(n));
   genGraph(question[n],out,opt,fileName)
end

function runForAll(dataFile,optionsFile, removeColumnsUpTo)
    setFile(dataFile, true, removeColumnsUpTo);
    setFile(optionsFile,false,removeColumnsUpTo);
    #just for now
    #global opt = alternatives(option[!,question[n]]);
    #relateTables()
    i=1;
    while i in 1:length(names(data))
        println("Gerando arquivo nº ", i);
        runForIndex(i);
        i+=1;
    end
end
