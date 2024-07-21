namespace IhmLlamaMvc.CacheManager.Constants;

/// <summary>
/// Fichier de centralisation des constantes
/// Objectif : simplifier la maintenance en cas de changement de nom
/// </summary>
public static class Constantes
{
    // Racine de la configuration dans appsettings.json
    //    public const string foodexConfiguration = "FoodexConfiguration";

    // appsettings keys
    public const string connectionString = "ApplicationSettings:ConnectionString";
    public const string hasReferenceTechnique = "HasReferenceTechnique";

    public const string cacheConfiguration = "CacheConfiguration";
    public const string cacheConfigurationMonitoring = "CacheConfiguration:Monitoring";

    // Procédures stockées
    public const string spGetTraductionCodeFoodex = "P_FOODEX_S_TRADUCTION_CODE_FOODEX";

    public const string spUpdateEfsaSearchState = "P_FOODEX_U_EFSA_SEARCH_STATE";

    public const string spGetRefTechnique = "P_REF_S_REF_REFERENCE_TECHNIQUE";

    // clés du cache
    public const string referenceTechnique = "_referenceTechnique";


    //     public const string cacheDic = "_cacheDic";
    public const string cacheStatistiques = "_cacheStatistiques";
}