export interface IRecommendation {
    benefits: string;
    capacity: string;
    description: string;
    price_range: string;
    type: string;
}

export interface IRecommendationData {
    recommendations: IRecommendation[];
    workspace_id: string;
    workspace_name: string;
    workspace_type: string;
}

export interface IRecommendationResponse {
    data: IRecommendationData;
    status: string;
    timestamp: string;
}