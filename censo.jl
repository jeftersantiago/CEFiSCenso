using CSV, DataFrames
include("graph.jl")

data = CSV.read("inst.csv", DataFrame)
option = CSV.read("opt_inst.csv", DataFrame)

# censo institucional
## removendo as colunas data, nome e nº usp
select!(data, Not(1:3))
select!(option, Not(1:3))

# sobre número de pessoas que responderam
#x = ["Física", "Ciências Físicas e Biomoleculares", "Física Computacional"]
# número de pessoas em cada curos
# TODO: deixa dinamico
#y = [33, 33, 33]
# gráfico em barra para o número de pessoas em cada curso
#pie(x, y, title = "Quantidade de alunos que responderam por curso", l = 0.5)


question = getindex(names(option), 1:length(names(option)))

# Exemplo de como recuperar lista de valores
# ano = data[!, perguntas[1]]
#ponderada(df[!, perguntas[3]])

# create a funtion that runs the command df[!,quest[x]]

# thrghout the whole dataset and it must do the following:

# 1) Create a dynamic array of values that are going to increment
# every time an equal option appears.

# 2) Store, only one time, the alternative, a string.

# 3) Remember to check in the loop if the alternative in the loop
# was already stored.
# at the end of the function call the barGraph()

# 4) Store images in the barGraph() function.

# i must take all alternatives that ARE NOT missing and generate the options
# in the graph
# optList = option[!,question[i]]
function alternatives(optList) 
    i = 1;
    n = length(optList) -  length(findall(ismissing,optList));
    # ta dando problema na declaração desse vetor
    # rodar o código pra ver
    genList = Array{AbstractString,1}(undef,n);

    while i in 1:length(optList) 
        if !isequal(optList[i],missing)
            println(i)
            append!(genList, optList(i));
       end
            i+=1;
    end
    return genList;
end




#function realCensus(quest,ans)
#    values = alternatives = 0 ;
#    i=1;
#    while i in 1:length(quest)
#        x=1;
#        while x in 1:length(ans[!,quest[i]])
#            # fazer a ordenação vai ser complicado!
#            end
#        barGraph(quest[i], length(alternatives),alternatives,values)
#        i++;
#        values = alternatives = 0;
#        end
#    end

# Gráfico das médias ponderadas
function ponderada(list)
    # não gosto disso, mas não pensei em nenhuma fórmula melhor ainda
    option=["Entre 0 e 4", "Entre 4.1 e 6", "Entre 6.1 e 8", "Entre 8.1 e 9", "Entre 9.1 e 10"]
    vals = [0, 0, 0, 0, 0]; 
    i=1
    while i in 1:length(list)
        if getindex(list,i)==option[1] vals[1]+=1 end
        if getindex(list,i)==option[2] vals[2]+=1 end
        if getindex(list,i)==option[3] vals[3]+=1 end
        if getindex(list,i)==option[4] vals[4]+=1 end
        if getindex(list,i)==option[4] vals[5]+=1 end
        i+=1
    end
    barGraph("Média ponderada (com reprovações)",[1,2,3,4,5], option , vals)
end


# Exemplo de uso 
#option = ["Muito Insatisfeito", "Insatisfeito", "Pouco Insatisfeito", "Satisfeito", "Muito Satisfeito"]
#ans = [34,44,54,43,13];
# barGraph("Pergunta",[1,2,3,4,5], option, ans)
#                    [1:5] não funcionou :o 
