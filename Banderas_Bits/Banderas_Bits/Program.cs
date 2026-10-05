using System;

class Banderas_Bits
{
    // Creación de bits de banderas
    public const uint Flag_0 = 1U << 0;
    public const uint Flag_1 = 1U << 1;
    public const uint Flag_2 = 1U << 2;
    public const uint Flag_3 = 1U << 3;
    public const uint Flag_4 = 1U << 4;
    public const uint Flag_5 = 1U << 5;
    public const uint Flag_6 = 1U << 6;
    public const uint Flag_7 = 1U << 7;

    // Métodos de banderas
    public static void Encenderbandera(ref uint flags, uint mask)
    {
        flags |= mask;
    }

    public static void Apagarbandera(ref uint flags, uint mask)
    {
        flags &= ~mask;
    }

    public static bool Comprobarbandera(uint flags, uint finalmask)
    {
        return (flags & finalmask) == finalmask;
    }

    public static bool Invertirbandera(ref uint flags, uint mask, uint invalidStateMask)
    {
        flags ^= mask;

        // Si genera un estado prohibido, deshace el cambio y retorna false
        if ((flags & invalidStateMask) == invalidStateMask)
        {
            flags ^= mask;
            return false;
        }

        return true;
    }

    static void Main(string[] args)
    {
        uint flags = 0U;

        // Prueba 1: Encender banderas[cite: 1]
        Encenderbandera(ref flags, Flag_0 | Flag_1);
        Console.WriteLine($"1. Encender (Flag_0 y Flag_1): {Convert.ToString(flags, 2).PadLeft(8, '0')}");

        // Prueba 2: Comprobar banderas[cite: 1]
        bool esValido = Comprobarbandera(flags, Flag_0 | Flag_1);
        Console.WriteLine($"2. Comprobar estado crítico: {esValido}");

        // Prueba 3: Apagar bandera[cite: 1]
        Apagarbandera(ref flags, Flag_0);
        Console.WriteLine($"3. Apagar Flag_0: {Convert.ToString(flags, 2).PadLeft(8, '0')}");

        // Prueba 4: Invertir bandera con reversión automática[cite: 1]
        Encenderbandera(ref flags, Flag_6);
        uint mascaraProhibida = Flag_6 | Flag_7;

        bool resultado = Invertirbandera(ref flags, Flag_7, mascaraProhibida);
        Console.WriteLine($"4. Intentar Invertir a estado prohibido -> Éxito: {resultado}");
        Console.WriteLine($"   Valor final mantenido: {Convert.ToString(flags, 2).PadLeft(8, '0')}");
    }
}