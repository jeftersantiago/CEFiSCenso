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

    disciplinas = optionsFor(data,1)[1];

#    for i in disciplinas

        is_equal(name::String) = name == disciplinas # i 

        for j in 2:2#length(data.questions)
            println("j = ", j);
            dict = Dict();

            for l in optionsFor(data,j)
                dict[l] = 0;
            end


            df = DataFrame(A = answersFor(data,1), B = answersFor(data, j));

            println("\n", questionFor(data,j), "\n")

            tmp_qt = filter(:A => is_equal,df);
            tmp_ans = groupby(tmp_qt, :B);

            for k in 1:tmp_ans.ngroups
                tmp_list = tmp_ans[k];
                size = length(tmp_list.B);
                dict[getindex(tmp_list.B,1)] = size;
            end
            println("DICT : \n",dict)
            ans = [];# change this 1 later



#            for l in 2:



#           qt = questionFor(data,2);
#           opt = sort(optionsFor(data,2));
#           fileName = disciplinas * j;
#           barChart(qt,ans,opt,fileName);
        end
#    end
end






