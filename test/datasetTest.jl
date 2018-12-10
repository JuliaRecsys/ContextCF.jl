@testset "Datasets Kernel Tests" begin
    df = createDummyContextDataset()
    dataset = ContextCF.DatasetContext(df,:isWeekend,:notWeekend)

    @testset "Dummy Tests" begin
        @test dataset.users == 7
        @test dataset.items == 6
        @test length(dataset.metaContext) == 2
        @test size(dataset) == (7, 6, 2)
    end
    # 
    # @testset "Index Tests" begin
    #     @testset "Cartesian Index Tests" begin
    #         for i = 1:size(df)[1]
    #             user = df[:user][i]
    #             item = df[:item][i]
    #             contexts = ContextCF.context(dataset)
    #             for context in contexts
    #                 @test df[context][i] == dataset[user,item,context]
    #             end
    #         end
    #     end
    #     @testset " Column Index Tests" begin
    #
    #         ## por usuário
    #         for u in 1:Persa.users(dataset)
    #             for (user,item,rating) in dataset[user,:]
    #                 @test ContextCF.value(dataset[user,item]) == ContextCF.value(rating)
    #             end
    #         end
    #
    #         # TODO
    #         # for (u,v,r) in dataset
    #         # 	for c in context(dataset)
    #         # 		dataset[u,v,c] == r[c]
    #         # 	end
    #         # end
    #
    #         ## por item
    #         ##Pendente determinar como vai ser o objeto contextRating missing,
    #         # for item in 1:Persa.items(dataset)
    #         #     for (user, rating) in dataset1[:, item]
    #         #         @test dataset[user, item] == value(rating)
    #         #     end
    #         # end
    #     end
    #
    #     @testset "Iterator Tests" begin
    #         ## Testa se o valor dos ratings das iterações está correto
    #         for (user, item, rating) in dataset
    #             for context in ContextCF.context(dataset)
    #                 @test dataset[user,item,context] == ContextCF.value(rating,context)
    #             end
    #         end
    #
    #         ## Testa se todos os itens possuem o Meta dado igual
    #         for (user, item, rating) in dataset
    #             @test ContextCF.context(dataset) == ContextCF.context(rating)
    #         end
    #     end
    # end
    # end
end
