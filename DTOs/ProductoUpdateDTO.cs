﻿namespace TiendaAPI.DTOs
{
    public class ProductoUpdateDTO
    {
        public string Nombre { get; set; }
        public string Descripcion { get; set; }
        public decimal Precio { get; set; }
        public int Stock { get; set; }
        public int Id_Categoria { get; set; }
        public int Id_Proveedor { get; set; }
    }
}

