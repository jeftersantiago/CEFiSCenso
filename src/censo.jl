include("dataHandling.jl")

global data;

function censoInstitucional(dataFile::String,optionsFile::String, removeColumnsUpTo::Int64)
    global  data = setData(dataFile, optionsFile,removeColumnsUpTo);
    
    i=1;
    while i in 1:length(names(data.answers))
        println("Gerando arquivo nº ", i);
        runForIndex(i,data)
        i+=1;
    end
end

function censoDisciplinas(dataFile::String,optionsFile::String, removeColumnsUpTo::Int64)
    global data = setData(dataFile, optionsFile, removeColumnsUpTo);
    
    disciplinas = optionsFor(data,1);
    
    for i in disciplinas
        
        is_equal(name::String) = name ==  i 

        for j in 2:length(data.questions)

#            printstyled("Questão número = " * string(j) * "\n", color =:green);

            dict = Dict();

            qt = questionFor(data,j);
            opt = optionsFor(data,j);
            ans = answersFor(data,j);
            
            for l in optionsFor(data,j)
                dict[string(l)] = 0;
            end

            df = DataFrame(A = answersFor(data,1), B = ans);

#            printstyled("=========== \n" * questionFor(data,j) * "\n =========== ", color =:red);


            tmp_qt = filter(:A => is_equal,df);
            tmp_ans = groupby(tmp_qt, :B);

            for k in 1:tmp_ans.ngroups
                # no arquivo de template as perguntas de multiplas escolhas devem
                # conter opções nulas.               
                if(!isempty(optionsFor(data,j))) # fazer a função que pra aceitar várias respostas
                    tmp_list = tmp_ans[k];
                    size = length(tmp_list.B);
                    dict[string(getindex(tmp_list.B,1))] = size;
                end

            end

#           printstyled("\nRespostas\n",color =:green);
#           pretty_print(dict);
#           printstyled("Nº Respostas = ", color =:red);
#           print(length(dict));
#           printstyled("\n Opções \n", color =:green);
#           println(opt);
#           printstyled("Nº de opções = ", color =:red);
#           println(length(opt));
            
            formatted_ans =  Array{Int64,1}(undef,length(opt));



            k = 1;
            while length(dict) > 0 && length(ans) > k
                formatted_ans[k] = dict[optionsFor(data,j)[k]];
                delete!(dict,string(opt[k]));
                k += 1;
            end
#            printstyled("Respostas: ", color =:blue);
#            println(formatted_ans);
            fileName = i * " - " * string(j) * ".pdf";
            barChart(qt,formatted_ans,opt,fileName);
        end
    end
end
