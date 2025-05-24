using Dapper;
using Microsoft.AspNetCore.Mvc;
using TiendaAPI.Data;
using TiendaAPI.DTOs;
using TiendaAPI.Models;

namespace TiendaAPI.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class ProductosController : ControllerBase
    {
        private readonly DbContextDapper _dapper;

        public ProductosController(DbContextDapper dapper)
        {
            _dapper = dapper;
        }

        [HttpGet]
        public async Task<ActionResult<IEnumerable<Producto>>> GetProductos()
        {
            string sql = "SELECT * FROM listar_productos();";
            var productos = await _dapper.CreateConnection().QueryAsync<Producto>(sql);
            return Ok(productos);
        }

        [HttpPost]
        public async Task<ActionResult> CrearProducto([FromBody] ProductoCreateDTO productoDTO)
        {
            // Validaciones 
            if (productoDTO.Precio < 0)
                return BadRequest("El precio no puede ser negativo.");

            if (productoDTO.Stock < 0)
                return BadRequest("El stock no puede ser negativo.");

            if (string.IsNullOrWhiteSpace(productoDTO.Nombre))
                return BadRequest("El nombre del producto es obligatorio.");

            string sql = @"
SELECT insertar_producto(
    @Nombre,
    @Descripcion,
    @Precio,
    @Stock,
    @Id_Categoria,
    @Id_Proveedor
);";

            try
            {
                await _dapper.CreateConnection().ExecuteAsync(sql, productoDTO);
                return Ok("Producto creado correctamente.");
            }
            catch (Exception ex)
            {
                return BadRequest("No se pudo crear el producto. Error: " + ex.Message);
            }
        }




        [HttpPut("{id}")]
        public async Task<ActionResult> ActualizarProducto(int id, [FromBody] ProductoUpdateDTO dto)
        {
            if (dto.Precio < 0)
                return BadRequest("El precio no puede ser negativo.");

            if (dto.Stock < 0)
                return BadRequest("El stock no puede ser negativo.");

            if (string.IsNullOrWhiteSpace(dto.Nombre))
                return BadRequest("El nombre del producto es obligatorio.");

            string sql = @"
UPDATE productos SET 
    nombre = @Nombre,
    descripcion = @Descripcion,
    precio = @Precio,
    stock = @Stock,
    id_categoria = @Id_Categoria,
    id_proveedor = @Id_Proveedor
WHERE id = @Id";

            var parametros = new
            {
                Id = id,
                dto.Nombre,
                dto.Descripcion,
                dto.Precio,
                dto.Stock,
                dto.Id_Categoria,
                dto.Id_Proveedor
            };

            int filasAfectadas = await _dapper.CreateConnection().ExecuteAsync(sql, parametros);

            if (filasAfectadas > 0)
                return Ok("Producto actualizado correctamente.");
            else
                return NotFound("Producto no encontrado.");
        }


        [HttpDelete("{id}")]
        public async Task<ActionResult> EliminarProducto(int id)
        {
            string sql = "SELECT eliminar_producto(@Id);";

            await _dapper.CreateConnection().ExecuteAsync(sql, new { Id = id });

            return Ok("Producto eliminado correctamente.");
        }


    }
}

