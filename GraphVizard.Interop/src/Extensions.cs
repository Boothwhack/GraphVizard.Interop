using System.Runtime.InteropServices;

namespace GraphVizard.Interop;

public static class Extensions
{
    public static IntPtr AGDATA(SWIGTYPE_p_Agnode_t n)
    {
        /*
         * Imitates C macro: #define AGDATA(obj) (((Agobj_t *)(obj))->data)
         * Assumes 'n' is a pointer to struct Agobj_s
         * offsetof(Agobj_s, Agobj_s::data) == 16
         */

        return SWIGTYPE_p_Agnode_t.getCPtr(n).Handle + 16;
    }

    public static Position ND_coord(SWIGTYPE_p_Agnode_t n)
    {
        /*
         * Imitates C macro: #define ND_coord(n) (((Agnodeinfo_t*)AGDATA(n))->coord)
         * Assumes 'n' is pointer to struct Agnodeinfo_t
         * offsetof(Agnodeinfo_t, Agnodeinfo_t::coord) == 32
         */

        var data = Marshal.ReadIntPtr(AGDATA(n));
        var ptr = data + 32;
        return Marshal.PtrToStructure<Position>(ptr);
    }
}