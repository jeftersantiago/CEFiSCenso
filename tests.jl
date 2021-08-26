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
# Exemplo de como recuperar lista de valores
# ano = data[!, perguntas[1]]
#ponderada(df[!, perguntas[3]])



# Exemplo de uso 
#option = ["Muito Insatisfeito", "Insatisfeito", "Pouco Insatisfeito", "Satisfeito", "Muito Satisfeito"]
#ans = [34,44,54,43,13];
# barGraph("Pergunta",[1,2,3,4,5], option, ans)
