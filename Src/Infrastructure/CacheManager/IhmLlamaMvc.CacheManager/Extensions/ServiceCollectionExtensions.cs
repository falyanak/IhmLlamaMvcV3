using IhmLlamaMvc.CacheManager.Constants;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using SiccrfCacheManager.Nuget.Configurations;
using SiccrfCacheManager.Nuget.Enums;
using SiccrfCacheManager.Nuget.Interfaces;
using SiccrfCacheManager.Nuget.MemoryCache;
using SiccrfCacheManager.Nuget.Services;

namespace IhmLlamaMvc.CacheManager.Extensions;

public static class ServiceCollectionExtensions
{
    public static void AddCacheInfrastructure(this IServiceCollection services, 
        IConfiguration configuration, Serilog.ILogger logger)
    {
        services.AddMemoryCache();

        // Associer la configuration du cache définie dans Appsettings à la classe CacheConfiguration
        services.Configure<CacheConfiguration>(configuration.GetSection(Constantes.cacheConfiguration));

        // injecter le service de gestion du cache en fonction de la configuration de appsettings.json
        services.AddMemoryCacheFactory(configuration, logger);

        // injecter le service de statistiques d'utilisation du cache
        services.AddScoped<ICacheStatisticService, CacheStatisticService>();
    }

    public static void AddMemoryCacheFactory(this IServiceCollection services, 
        IConfiguration configuration, Serilog.ILogger logger)
    {
        // Associer la configuration du cache définie dans Appsettings à la classe CacheConfiguration
        services.Configure<CacheConfiguration>(configuration.GetSection(Constantes.cacheConfiguration));

        // lire la valeur CacheConfiguration:Monitoring dans le fichier appsettings.json
        bool.TryParse(configuration[Constantes.cacheConfigurationMonitoring], out bool isCacheMonitoring);

        MemoryCacheOptionEnum memoryCacheOption = isCacheMonitoring
            ? MemoryCacheOptionEnum.MonitoredMemoryCache
            : MemoryCacheOptionEnum.MemoryCache;

        switch (memoryCacheOption)
        {
            case MemoryCacheOptionEnum.MemoryCache:
                services.AddSingleton<IMemoryCacheService, MemoryCacheService>();
                break;

            case MemoryCacheOptionEnum.MonitoredMemoryCache:
                services.AddSingleton<IMemoryCacheService, MonitoredMemoryCacheService>();
                break;

            default:
                throw new ArgumentOutOfRangeException(nameof(memoryCacheOption), memoryCacheOption,
                    $"MemoryCacheOptionEnum de {memoryCacheOption} n'est pas reconnu.");
        }
    }
}