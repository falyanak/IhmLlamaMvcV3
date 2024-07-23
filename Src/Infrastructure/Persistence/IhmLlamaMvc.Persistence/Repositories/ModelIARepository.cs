using IhmLlamaMvc.Domain.Entites.IaModels;
using IhmLlamaMvc.Persistence.EF;
using IhmLlamaMvc.SharedKernel.Primitives;
using IhmLlamaMvc.SharedKernel.Primitives.Result;
using Microsoft.EntityFrameworkCore;

namespace IhmLlamaMvc.Persistence.Repositories
{
    public class ModelIARepository : IModelIARepository
    {
        private readonly ChatIaDbContext _dBContext;

        public ModelIARepository(ChatIaDbContext dBContext)
        {
            _dBContext = dBContext;
        }
        public async Task<Result<IReadOnlyList<ModeleIA>>> ChargerModelesIA()
        {
            var modelesIAList = new List<ModeleIA>();
            try
            {
                modelesIAList = await _dBContext.IaModels.ToListAsync();
            }
            catch (Exception ex)
            {
                return Result.Failure<IReadOnlyList<ModeleIA>>(
                    new Error("ModelIA.Lister.error", ex.Message));
            }

            return modelesIAList;
        }
    }
}
