using IhmLlamaMvc.Application.Configurations;
using IhmLlamaMvc.Application.Constants;

namespace IhmLlamaMvc.Mvc.Extensions;

/// <summary>
/// Extension de la classe services pour isoler la configuration SICCRF
/// </summary>
public static class ServiceCollectionExtensions
{
    public static void AddInfrastructure(this IServiceCollection services,
        IConfiguration configuration, Serilog.ILogger logger)
    {
        logger.Information("Ajout des services d'infrastructure");
        AddApplicationSettings(services, configuration, logger);

        WebApi.Extensions.ServiceCollectionExtensions.AddWebApiAccessServices(services, configuration, logger);
       
        Authorization.Extensions.ServiceCollectionExtensions.AddAuthorization(services, configuration, logger);

        CacheManager.Extensions.ServiceCollectionExtensions.AddCacheInfrastructure(services, configuration, logger);

        Persistence.Extensions.ServiceCollectionExtensions.AddPersistenceInfrastructure(services, configuration, logger);

        IaModelLlamaProvider.Extensions.ServiceCollectionExtensions.AddModelIaProvidersInfrastructure(services, configuration, logger);

        logger.Information("Fin d'ajout des services d'infrastructure");
    }


    //internal static IApplicationBuilder UseCustomExceptionHandler(this IApplicationBuilder builder)
    //    => builder.UseMiddleware<CustomExceptionHandlerMiddleware>();

    public static void AddApplicationSettings(this IServiceCollection services,
        IConfiguration configuration, Serilog.ILogger logger)
    {

        //  services.Configure<SchedulerSettings>(configuration.GetSection("Scheduler"));

        // Associer la configuration du cache définie dans Appsettings à la classe ApplicationSettings
        services.Configure<ApplicationSettings>(configuration.GetSection(
            Constantes.applicationSettings));



    }

}