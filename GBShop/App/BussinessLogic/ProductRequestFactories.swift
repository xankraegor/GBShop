import Alamofire

protocol AddProductRequestFactory {
    
    func addProduct(
        productId: Int,
        quantity: Int,
        completionHandler: @escaping (DataResponse<AddProductResult>) -> Void)
    
}

protocol RemoveProductRequestFactory {
    
    func removeProduct(
        productId: Int,
        completionHandler: @escaping (DataResponse<RemoveProductResult>) -> Void)
    
}

protocol GetBasketRequestFactory {
    
    func getBasket(
        userId: Int,
        completionHandler: @escaping (DataResponse<GetBasketResult>) -> Void)
    
}

protocol CatalogDataRequestFactory {
    
    func catalogData(
        pageNumber: Int,
        categoryId: Int,
        completionHandler: @escaping (DataResponse<CatalogDataResult>) -> Void)
    
}
