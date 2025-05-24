using System.Data;
using Npgsql;

namespace TiendaAPI.Data
{
    public class DbContextDapper
    {
        private readonly IConfiguration _config;
        private readonly string _connectionString;

        public DbContextDapper(IConfiguration config)
        {
            _config = config;
            _connectionString = _config.GetConnectionString("DefaultConnection");
        }

        public IDbConnection CreateConnection()
        {
            return new NpgsqlConnection(_connectionString);
        }
    }
}

