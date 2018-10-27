using Persa
using ContextCF
using Test
using DataFrames

function createDummyContextDataset()
    df = DataFrame()
    df[:user] = [1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2, 3, 3, 3, 3, 4, 4, 4, 4, 4, 5, 5, 5, 5, 5, 5, 6, 6, 6, 6, 6, 7, 7, 7]
    df[:item] = [1, 2, 3, 4, 5, 6, 1, 2, 3, 4, 5, 6, 1, 2, 3, 4, 2, 3, 4, 5, 6, 1, 2, 3, 4, 5, 6, 1, 2, 4, 5, 6, 2, 4, 5]
    df[:rating] = [2, 7, 3, 3, 8, 3, 3, 3, 1, 9, 3, 3, 2, 3, 10, 4, 3, 3, 4, 2, 4, 3, 4, 2, 3, 2, 3, 3, 4, 5, 9, 10, 7, 6, 8]
	df[:isWeekend] = [true,false,true,true,false,true,false,true,false,false,true,false,true,true,false,true,false,true,false,false,true,false,true,true,false,true,false,true,false,false,true,false,false,false,true]
	df[:notWeekend] = map(x -> !x,df[:isWeekend])

    return df
end

function createDummyContextDataset2()
    df = DataFrame()
    df[:user] = [1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2, 3, 3, 3, 3, 4, 4, 4, 4, 4, 5, 5, 5, 5, 5, 5, 6, 6, 6, 6, 6, 7, 7, 7]
    df[:item] = [1, 2, 3, 4, 5, 6, 1, 2, 3, 4, 5, 6, 1, 2, 3, 4, 2, 3, 4, 5, 6, 1, 2, 3, 4, 5, 6, 1, 2, 4, 5, 6, 2, 4, 5]
    df[:rating] = [0.5, 5.0, 3.0, 4.5, 8, 3, 3, 1.5, 1, 9, 3, 3, 2, 3, 4, 4, 3, 3, 4, 2, 4, 3, 4, 2, 3, 2, 3, 3, 4, 5, 3.5, 4.0, 2.5, 4, 3.5]
	df[:isWeekend] = [true,false,true,true,false,true,false,true,false,false,true,false,true,true,false,true,false,true,false,false,true,false,true,true,false,true,false,true,false,false,true,false,false,false,true]
	df[:dayWeek] = [1,2,3,4,5,4,5,1,2,3,4,5,4,5,1,2,3,4,5,4,5,1,2,3,4,5,4,5,1,2,3,4,5,4,5]
	df[:isHappy] = [missing, true, false, true, false, missing, missing, missing, true, false, true, false, missing, missing,missing, true, false, true, false, missing, missing,missing, true, false, true, false, missing, missing,missing, true, false, true, false, missing, missing]

	return df
end

metaContext = Dict(:isWeekend => Bool, :dayWeek => Int, :isHappy => Bool)
dataset = ContextCF.DatasetContext(createDummyContextDataset2(),metaContext)

dataset[1,1,3]

####
include("datasetTest.jl")
