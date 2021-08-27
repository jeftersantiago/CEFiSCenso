using CSV, DataFrames
include("graph.jl")

# deixar isso dinamico também, permitir passar o nome do arquivo em uma função
data = CSV.read("inst.csv", DataFrame)
option = CSV.read("opt_inst.csv", DataFrame)

# censo institucional
## removendo as colunas data, nome e nº usp
select!(data, Not(1:3))
select!(option, Not(1:3))

# lista com as perguntas
question = getindex(names(option), 1:length(names(option)))
# como declarar lista com opções
# opt = option[!,question[i]]

# sobre número de pessoas que responderam
#x = ["Física", "Ciências Físicas e Biomoleculares", "Física Computacional"]
# número de pessoas em cada curos
#y = [33, 33, 33]
# gráfico em barra para o número de pessoas em cada curso
#pie(x, y, title = "Quantidade de alunos que responderam por curso", l = 0.5)


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

# 1) Create a dynamic array of values that are going to increment
# every time an equal option appears.
# run through the array and list in a new array the values
# optList must come from alternatives(x)
function setData(dataList,optList)
# list is the list with the answers accounted for each option
    # declarer array that will be counting
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


function run(n)
    println(question[n]);
    opt = alternatives(option[!,question[n]]);
    println(opt);
    ans = data[!,n];
    out = setData(ans,opt);
    #println("Number of answers = " , out[1] + out[2] + out[3] + out[4] + out[5])
    fileName = string("pergunta",string(n));
    barGraph(question[n], [1:length(out)], opt, out, fileName );
end

j=1;
while j in 1:43
 println("Arquivo nº " , j);
 run(j);
 global j+=1;
end



