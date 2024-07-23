using IhmLlamaMvc.Application.Interfaces;
using IhmLlamaMvc.Domain.Entites.IaModels;
using IhmLlamaMvc.SharedKernel.Primitives.Result;
using MediatR;

namespace IhmLlamaMvc.Application.UseCases.IaModels.Queries;

/// <summary>
/// Represents the <see cref="ListerModelesIAQuery"/> handler.
/// </summary>
internal sealed class ListerModelesIAQueryHandler :
    IRequestHandler<ListerModelesIAQuery, Result<IReadOnlyList<ModeleIA>>>
{
    private readonly IChatIaService _chatIaService;
    public ListerModelesIAQueryHandler(IChatIaService chatIaService)
    {
        _chatIaService = chatIaService;
    }
    /// <inheritdoc />
    public async Task<Result<IReadOnlyList<ModeleIA>>>
        Handle(ListerModelesIAQuery listerModelesIaQuery, CancellationToken cancellationToken)
    {
        var listeModeles = await _chatIaService.ListerModelesIA();

        return listeModeles;
    }
}