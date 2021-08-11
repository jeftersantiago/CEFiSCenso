using Printf, Plots
using StatsPlots
using CSV, DataFrames

df = CSV.read("institucional.csv", DataFrame)

# removendo as colunas data, nome e nº usp
select!(df, Not(1:3))

# sobre número de pessoas que responderam
#x = ["Física", "Ciências Físicas e Biomoleculares", "Física Computacional"]
#y = [33, 33, 33]
#pie(x, y, title = "Quantidade de alunos que responderam por curso", l = 0.5)


perguntas = getindex(names(df), 1:length(names(df)))
# Exemplo de como recuperar lista de valores
# ano = df[!, perguntas[1]]

# Gráfico das médias ponderadas
function ponderada(list)
    # não gosto disso, mas não pensei em nenhuma fórmula melhor ainda
    n=["Entre 0 e 4", "Entre 4.1 e 6", "Entre 6.1 e 8", "Entre 8.1 e 9", "Entre 9.1 e 10"]
    vals = [0, 0, 0, 0]; 
    i=1
    while i in 1:length(list)
        if getindex(list,i)==n[1] vals[1]+=1 end
        if getindex(list,i)==n[2] vals[2]+=1 end
        if getindex(list,i)==n[3] vals[3]+=1 end
        if getindex(list,i)==n[4] vals[4]+=1 end
        i+=1
    end
    return vals
end

# Gera um gráfico em barra para as perguntas com 5 alternativas
function barGraph(questTitle, options, ans )
x = [1,2,3,4,5];
y = ans; 
Plots.bar(x,y, title=questTitle,xticks=(1:5, options), legend=false,grid=false)
end

# Exemplo de uso 
# options = ["Muito Insatisfeito", "Insatisfeito", "Pouco Insatisfeito", "Satisfeito", "Muito Satisfeito"]
# ans = [34,44,54,43,13];
# barGraph("Pergunta", options, ans)






