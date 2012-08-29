package freyja.statechart 
{
	/**
     * 代表 state machine 之中的一個 state。
     */
    public class State 
    {
        private var m_name: String = "";
        
        private var m_reactions: Object = new Object;
        

        public function get name() : String
        {
            return m_name;
        }
        
        
        public function State( name: String ) 
        {
            m_name = name;
        }
        
        public function AddTransition( eventName: String, targetStateName: String, action: Function = null ) : State
        {
            if ( null != m_reactions[ eventName ] )
            {
                throw Error( "Reaction of event " + eventName + " already existed in state " + m_name );
            }
            
            m_reactions[ eventName ] = new Transition( targetStateName, action );
            return this;
        }
        
        public function AddInStateReaction( eventName: String, action: Function ) : State
        {
            if ( null != m_reactions[ eventName ] )
            {
                throw Error( "Reaction of event " + eventName + " already existed in state " + m_name );
            }
            
            m_reactions[ eventName ] = new Reaction( action );
            return this;
        }
        
        internal function FindReaction( eventName: String ) : Reaction
        {
            var reaction: Reaction = m_reactions[ eventName ];
            if ( null == reaction )
            {
                trace( "Reaction of event \"" + eventName + "\" not found in state \"" + m_name + "\"" );
                return null;
            }
            
            return reaction;
        }
    }
}
