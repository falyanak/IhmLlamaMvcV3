using IhmLlamaMvc.Persistence.Constants;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Logging;
using SiccrfCacheManager.Nuget.Entites;
using SiccrfCacheManager.Nuget.Interfaces;

namespace IhmLlamaMvc.Persistence.Services;

public class CacheStatisticService : ICacheStatisticService
{
    /// Journalisation
    /// </summary>
    private readonly ILogger<CacheStatisticService> _logger;

    /// <summary>
    /// accès à la configuration du fichier Appsettings
    /// </summary>
    private readonly IConfiguration _configuration;

    /// Journalisation
    /// </summary>
    private readonly IMemoryCacheService _memoryCacheService;

    /// <summary>
    /// Constructuer avec injection de dépendances
    /// </summary>
    /// <param name="dapperDataAccess"></param>
    /// <param name="memoryCacheService"></param>
    /// <param name="configuration"></param>
    public CacheStatisticService(IMemoryCacheService memoryCacheService, IConfiguration configuration,
        ILogger<CacheStatisticService> logger)
    {
        _memoryCacheService = memoryCacheService;
        _configuration = configuration;
        _logger = logger;
    }

    public IEnumerable<CacheStatistic> GetCacheStatisticList()
    {
        IEnumerable<CacheStatistic> list = new List<CacheStatistic>();

        if (_memoryCacheService.TryGetValue(Constantes.cacheStatistiques, out Dictionary<string, CacheStatistic> cacheStatDic))
        {
            list = cacheStatDic.Values.ToList();
        }

        return list;
    }
}