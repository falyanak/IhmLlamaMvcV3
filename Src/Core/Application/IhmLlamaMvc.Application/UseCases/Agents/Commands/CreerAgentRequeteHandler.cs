using IhmLlamaMvc.Domain.Entites.Agents;
using IhmLlamaMvc.SharedKernel.Primitives.Result;
using MediatR;

namespace IhmLlamaMvc.Application.UseCases.Agents.Commands
{
    public sealed class CreerAgentRequeteHandler : 
        IRequestHandler<CreerAgentRequete, Result<Agent>>
    {
        private readonly IAgentRepository _agentRepository;

        public CreerAgentRequeteHandler(IAgentRepository agentRepository)
        {
            _agentRepository = agentRepository;
        }

        /// <inheritdoc />
        public async Task<Result<Agent>> Handle(CreerAgentRequete request,
            CancellationToken cancellationToken)
        {
            var agent = new Agent(request.Nom, request.Prenom, request.LoginWindows);

            var creationAgent = await _agentRepository.CreerAgent(agent);
  
            return creationAgent;
        }
    }
}
