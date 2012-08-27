package freyja.mvc 
{
    public interface IView
    {
        function BindToModel( model: Model ) : void;

        function OnActivated() : void;
        function OnDeactivated() : void;

        function OnEnterFrame() : void;
    }

}