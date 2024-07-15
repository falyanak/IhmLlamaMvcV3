using System.Data;
using System.Diagnostics;
using Dapper;
using IhmLlamaMvc.Domain.Entites.Agents;
using IhmLlamaMvc.Persistence.Constants;
using IhmLlamaMvc.SharedKernel.Primitives.Result;
using SiccrfDataAccess.Nuget.Interfaces;
using Agent = IhmLlamaMvc.Domain.Entites.Agents.Agent;

namespace IhmLlamaMvc.Persistence.Repositories;

public  class AgentRepository : IAgentRepository
{
    private readonly IDataAccessService _dapperDataAccessService;

    public AgentRepository(IDataAccessService dapperDataAccessService)
    {
        _dapperDataAccessService = dapperDataAccessService;
    }

 

    public async Task<Result<Agent>> CreerAgent(Agent agent)
    {
        var parameters = new DynamicParameters();

        parameters.Add("@NOM", dbType: DbType.String, value: agent.Nom.Trim(), direction: ParameterDirection.Input);
        parameters.Add("@PRENOM", dbType: DbType.String, value: agent.Prenom.Trim(), direction: ParameterDirection.Input);
   
        var result = await _dapperDataAccessService
            .ExecSqlQuerySingleAsync<Agent>(Constantes.SpCreerAgent, parameters);

        return result;
    }

    public async Task SupprimerAgent(int agentId)
    {
        var parameters = new DynamicParameters();

        parameters.Add("@IDENT", dbType: DbType.Int16, value: agentId, direction: ParameterDirection.Input);

        await _dapperDataAccessService.ExecSqlQuerySingleAsync<Agent>(
            Constantes.SpSupprimerAgent, parameters);
    }

    public async Task<IReadOnlyCollection<Agent>> ListerAgents()
    {
        var parameters = new DynamicParameters();
        parameters.Add("@count", DbType.Int32, direction: ParameterDirection.Output);

        var listeAgents =
            await _dapperDataAccessService.ExecSqlQueryMultipleAsync<Agent>(
                Constantes.SpListerAgents, parameters);

        var count = parameters.Get<int>("@count");
        Debug.WriteLine($"****** ListerAgentsEnTotalite() = {count} lignes récupérées");

        return listeAgents.ToList().AsReadOnly();
    }


}