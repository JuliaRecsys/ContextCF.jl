@testset "Datasets Kernel Tests" begin
    df = createDummyContextDataset()
    metaContext = Dict(:isWeekend => Bool, :notWeekend => Bool)
    dataset = ContextCF.DatasetContext(df,metaContext)

    @testset "Dummy Tests" begin
        @test dataset.users == 7
        @test dataset.items == 6
        @test length(dataset.metaContext) == 2
        @test size(dataset) == (7, 6, 2)
    end

    @testset "Index Tests" begin
        @testset "Cartesian Index Tests" begin

        for i = 1:size(df)[1]
            user = df[:user][i]
            item = df[:item][i]
            contextRating = df[:isWeekend][i]
            @test contextRating == dataset[user,item,:isWeekend]
        end

    end
    end
end
