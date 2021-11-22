include("genCharts.jl")

using CSV, DataFrames
global data;

mutable struct Data 
    answers::DataFrame;
    options::DataFrame;
    questions::Vector{String};
end


function setData(dataPath::String,optionsPath,removeAt::Int64)

    answers = CSV.read(string(dataPath), DataFrame);
    select!(answers ,Not(1:removeAt));

    options = CSV.read(string(optionsPath),DataFrame);
    select!(options,Not(1:removeAt));


    questions = getindex(names(options), 1:length(names(options)));

    return Data(answers,options,questions);
end

function optionsFor(data::Data, index::Int64)::Vector{String}
    return setOptions(data.options[!,data.questions[index]]);
end

function optionsFor(index::Int64,data::Data)::Vector{String}
    return setOptions(data.options[!,data.questions[index]]); 
end

function answersFor(data::Data, index::Int64)
    return data.answers[!,index];
end

function answersFor(index::Int64,data::Data)
    return data.answers[!,index];
end

function questionFor(index::Int64,data::Data)
    return data.questions[index]; 
end
function questionFor(data::Data, index::Int64)
    return data.questions[index]; 
end

    # Removes 'missing' elements and returns the options list.
function setOptions(opt::AbstractArray)
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
function setAnswers(answers::AbstractArray,options::AbstractArray)
    formatedAnswers = Array{Int64,1}(undef,length(options));
    i=1;
    while i in 1:length(options)
        formatedAnswers[i] = 0;
        j=1;
        while j in 1:length(answers)
            if isequal(string(options[i]), string(answers[j]))
                formatedAnswers[i]+=1;
            end
            j+=1;
        end
        i+=1;
    end
    return formatedAnswers;
end

function runForIndex(n::Int64)
   global opt = setOptions(option[!,question[n]]);
   global ans = data[!,n];
   global out = setData(ans,opt);
   fileName = string("Grafico - ",string(n), ".pdf");
   barChart(question[n],out,opt,fileName);
end

function runForIndex(n::Int64, data::Data)
    fileName = string("Grafico - ",string(n), ".pdf");

    options = optionsFor(data,n);
    answers = answersFor(data,n); 
    formatedAnswers = setAnswers(answers,options);
    question = questionFor(data,n);

    barChart(question, formatedAnswers,options,fileName);
end

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
    relate(data);
end 



function relate(data::Data)

    disciplinas = optionsFor(data,1);

    for i in disciplinas

        is_equal(name::String) = name ==  i 

        for j in 2:length(data.questions)

            println("j = ", j);

            dict = Dict();

            qt = questionFor(data,j);
            opt = optionsFor(data,j);
            ans = answersFor(data,j);

            for l in optionsFor(data,j)
                dict[string(l)] = 0;
            end

            df = DataFrame(A = answersFor(data,1), B = ans);

            println("\n", questionFor(data,j), "\n")

            tmp_qt = filter(:A => is_equal,df);
            tmp_ans = groupby(tmp_qt, :B);

            println("HERE\n", tmp_ans);

            #           i = 1;
            #           new_ans = [];
            #           while i < length(tmp_ans)              
            #               each_ans = ans[i];
            #               tmp_split = split(each_ans, ", ");
            #               if(length(tmp_split) > 1)
            #                   for k in tmp_split
            #                       append!(new_ans,k);                        
            #                   end
            #               else
            #                   append!(new_ans,each_ans);
            #               end
            #               i += 1;
            #           end
            #           tmp_ans = new_ans;

            for k in 1:tmp_ans.ngroups
                if(j != 21)
                    tmp_list = tmp_ans[k];
                    size = length(tmp_list.B);
                    dict[string(getindex(tmp_list.B,1))] = size;
                end
            end

           println("Dicionario\n",dict);
           println("Nº valores = ",length(dict));
           println("Options\n", opt);
           println("Nº opções = ", length(opt));
            
            formatted_ans =  Array{Int64,1}(undef,length(opt));

            k = 1;
            while length(dict) > 0 && length(ans) > k
                formatted_ans[k] = dict[optionsFor(data,j)[k]];
                delete!(dict,string(opt[k]));
                k += 1;
            end
            #            println("answers = ", formatted_ans );

            fileName = i * " - " * string(j) * ".pdf";
            barChart(qt,formatted_ans,opt,fileName);
        end
    end
end






