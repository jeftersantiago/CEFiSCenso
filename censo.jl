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

# Percorre a lista de alternativa e remove os indices missing 
# Retorna a lista de opções, a partir da lista é possivel chamar a função
# de gráfico e etc.
# opt = option[!,question[i]]
function alternatives(opt) 
    i = 1;
    n = length(opt) -  length(findall(ismissing,opt));
    # não sei declarar array direito então aqui vai a gambiarra
    # declarei dessa forma e no final do loop removo o primeiro valor usando
    # a função popfirst
    list = [""] 
    while i in 1:length(opt) 
        if !isequal(opt[i],missing)
            # usa o push aqui pq não quero ter que lidar com o indice em cada array
            push!(list, opt[i]);
       end
            i+=1;
    end
    popfirst!(list);
    return reverse(list,1,length(list));
end



# isso vai ser alterado
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
