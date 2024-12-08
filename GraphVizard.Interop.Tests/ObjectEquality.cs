namespace GraphVizard.Interop.Tests;

public class ObjectEquality
{
    [Fact]
    public void GraphEquality()
    {
        var a = gv.digraph("Root Graph A");
        var b = gv.digraph("Root Graph B");
        // subgraphs with same name, but belonging to different root graphs
        var c = gv.graph(a, "Subgraph");
        var d = gv.graph(b, "Subgraph");

        Assert.Equal(a, a);
        Assert.NotEqual(a, b);
        Assert.NotEqual(a, c);
        Assert.NotEqual(a, d);
        Assert.Equal(a, gv.graphof(c));
        Assert.NotEqual(a, gv.graphof(d));

        Assert.NotEqual(b, a);
        Assert.Equal(b, b);
        Assert.NotEqual(b, c);
        Assert.NotEqual(b, d);
        Assert.NotEqual(b, gv.graphof(c));
        Assert.Equal(b, gv.graphof(d));

        Assert.NotEqual(c, a);
        Assert.NotEqual(c, b);
        Assert.Equal(c, c);
        Assert.NotEqual(c, d);
        Assert.Equal(c, gv.findsubg(a, "Subgraph"));
        Assert.NotEqual(c, gv.findsubg(b, "Subgraph"));
        
        Assert.NotEqual(d, a);
        Assert.NotEqual(d, b);
        Assert.NotEqual(d, c);
        Assert.Equal(d, d);
        Assert.NotEqual(d, gv.findsubg(a, "Subgraph"));
        Assert.Equal(d, gv.findsubg(b, "Subgraph"));
    }
}