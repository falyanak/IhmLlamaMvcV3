using IhmLlamaMvc.Application.Interfaces.Dal;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Logging;
using SiccrfCacheManager.Nuget.Interfaces;

namespace IhmLlamaMvc.Persistence.Services;

public class PermanentCachedDataService : IPermanentCachedDataService
{
    /// <summary>
    /// Journalisation
    /// </summary>
    private readonly ILogger<PermanentCachedDataService> _logger;

    /// <summary>
    ///  Accès aux méthodes du cache
    /// </summary>
    private readonly IMemoryCacheService _memoryCacheService;
    /// <summary>
    /// accès à la configuration du fichier Appsettings
    /// </summary>
    private readonly IConfiguration _configuration;
   
    public PermanentCachedDataService(
        IMemoryCacheService memoryCacheService, IConfiguration configuration,
        ILogger<PermanentCachedDataService> logger)
    {
        _memoryCacheService = memoryCacheService;
        _configuration = configuration;
        _logger = logger;
    }

    /// <summary>
    /// Construire les listes permanentes et les mettre en cache
    /// </summary>
    /// <returns></returns>
    public async Task BuildAllPermanentCachedData()
    {
        _logger.LogInformation("{permanentCachedDataService} {buildAllPermanentCachedData}" +
                               " Mise en cache des objets permanents",
            nameof(PermanentCachedDataService), nameof(BuildAllPermanentCachedData)
            );

      
        // mise en cache de la liste des
      

    }
}