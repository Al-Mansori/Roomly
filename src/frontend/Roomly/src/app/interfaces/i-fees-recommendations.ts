export interface IFeesRecommendationResponse {
  data: {
    recommendations: IFeesRecommendations[];
    workspace_id: string;
  };
  status: string;
  timestamp: string;
}

export interface IFeesRecommendations {
  CancellationRate: number;
  CompletionRate: number;
  PricePerHour: number;
  RecommendedFee: number;
  RecommendedFeePercentage: number;
  room_name: string;
  room_type: string;
}

