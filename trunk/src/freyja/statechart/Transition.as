package freyja.statechart 
{
	/**
     * ...
     */
    internal class Transition extends Reaction
    {
        private var m_targetStateName: String = "";
        
        
        internal function get targetStateName() : String
        {
            return m_targetStateName;
        }
        

        public function Transition( targetStateName: String, action: Function ) 
        {
            super( action );
            m_targetStateName = targetStateName;
        }
    }

}