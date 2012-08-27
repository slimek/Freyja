package freyja.statechart 
{
	/**
     * ...
     */
    public class Reaction 
    {
        private var m_action: Function = null;
        
        public function get action() : Function
        {
            return m_action;
        }
        
        public function Reaction( action: Function ) 
        {
            m_action = action;
        }
        
    }

}