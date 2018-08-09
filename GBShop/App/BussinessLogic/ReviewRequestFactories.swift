import Alamofire

protocol AddReviewRequestFactory {
    
    func addReview(
        userId: Int,
        review: String,
        completionHandler: @escaping (DataResponse<AddReviewResult>) -> Void)
}

protocol ApproveReviewRequestFactory {
    
    func approveReview(
        reviewId: Int,
        completionHandler: @escaping (DataResponse<ApproveReviewResult>) -> Void)
}

protocol RemoveReviewRequestFactory {
    
    func removeReview(
        reviewId: Int,
        completionHandler: @escaping (DataResponse<RemoveReviewResult>) -> Void)
}
