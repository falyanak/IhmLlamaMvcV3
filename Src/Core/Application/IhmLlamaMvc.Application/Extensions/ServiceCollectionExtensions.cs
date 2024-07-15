using System.Reflection;
using FluentValidation;
using IhmLlamaMvc.Application.Behaviors;
using IhmLlamaMvc.Application.Interfaces;
using MediatR;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.DependencyInjection.Extensions;
using ChatIaService = IhmLlamaMvc.Application.Services.ChatIaService;

namespace IhmLlamaMvc.Application.Extensions;

/// <summary>
/// Contains the extensions method for registering dependencies in the DI framework.
/// </summary>
public static class ServiceCollectionExtensions
{
    /// <summary>
    /// Registers the necessary services with the DI framework.
    /// </summary>
    /// <param name="services">The service collection.</param>
    /// <returns>The same service collection.</returns>
    public static IServiceCollection AddApplication(this IServiceCollection services)
    {
        services.AddValidatorsFromAssembly(Assembly.GetExecutingAssembly());

        services.AddTransient(typeof(IPipelineBehavior<,>), typeof(ValidationBehaviour<,>));

        services.AddMediatR(Assembly.GetExecutingAssembly());

        services.TryAddScoped<IChatIaService, ChatIaService>();

        return services;
    }
}