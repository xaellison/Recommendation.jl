function test_cross_validation_accuracy(v)
    m = [v 3 v 1 2 1 v 4
         1 2 v v 3 2 v 3
         v v v v v v v v
         v 2 3 3 v 5 v 1]
    data = DataAccessor(isa(v, Unknown) ? m : sparse(m))

    # 1-fold cross validation is invalid
    @test_throws ErrorException cross_validation(1, MAE, MF, data, 2)

    # in n-fold cross validation, n must be smaller than or equal to the number of all samples
    @test_throws ErrorException cross_validation(100, MAE, MF, data, 2)

    fold = 5

    # MF(data, 2)
    @test 0.0 < cross_validation(fold, MAE, MF, data, 2) <= 2.5

    # UserMean(data)
    @test 0.0 < cross_validation(fold, MAE, UserMean, data) <= 2.5

    # ItemMean(data)
    @test 0.0 < cross_validation(fold, MAE, ItemMean, data) <= 2.5

    # UserKNN(data, 2, true)
    @test 0.0 < cross_validation(fold, MAE, UserKNN, data, 2, true) <= 2.5

    # leave-one-out cross validation with MF(data, 2)
    n_samples = length(data.events)
    @test 0.0 < cross_validation(n_samples, MAE, MF, data, 2) <= 2.5
    @test 0.0 < leave_one_out(MAE, MF, data, 2) <= 2.5
end

function test_cross_validation_ranking(v)
    m = [v 3 v 1 2 1 v 4
         1 2 v v 3 2 v 3
         v 2 3 3 v 5 v 1]
    data = DataAccessor(isa(v, Unknown) ? m : sparse(m))

    # top-4 recommendation
    k = 4

    # 1-fold cross validation is invalid
    @test_throws ErrorException cross_validation(1, Recall, k, MF, data, 2)

    # in n-fold cross validation, n must be smaller than or equal to the number of all samples
    @test_throws ErrorException cross_validation(100, Recall, k, MF, data, 2)

    # 3-fold cross validation
    fold = 3

    # MF(data, 2)
    @test 0.0 <= cross_validation(fold, Recall, k, MF, data, 2) <= 1.0

    # MostPopular(data)
    @test 0.0 <= cross_validation(fold, Recall, k, MostPopular, data) <= 1.0

    # UserKNN(data, 2, true)
    @test 0.0 <= cross_validation(fold, Recall, k, UserKNN, data, 2, true) <= 1.0

    # leave-one-out cross validation with MF(data, 2)
    n_samples = length(data.events)
    @test 0.0 <= cross_validation(n_samples, Recall, k, MF, data, 2) <= 1.0
    @test 0.0 <= leave_one_out(Recall, k, MF, data, 2) <= 1.0
end

println("-- Testing cross validation with accuracy metrics")
test_cross_validation_accuracy(nothing)
test_cross_validation_accuracy(0)

println("-- Testing cross validation with ranking metrics")
test_cross_validation_ranking(nothing)
test_cross_validation_ranking(0)
