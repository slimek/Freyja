package freyja.statechart 
{
    import flash.utils.getTimer;

    /**
     *
     */
    public class StateMachine 
    {
        private var m_name: String = null;
        
        private var m_states: Object = new Object;
        private var m_events: Array  = new Array;

        private var m_currentState: State = null;
        private var m_transitTime: int = 0;
        private var m_canTransit: Boolean = false;
        
        
        public function get current() : String
        {
            if ( null == m_currentState )
            {
                throw Error( "State machine " + m_name + " not started yet" );
            }
            
            return m_currentState.name;
        }
        
        public function get elapsed() : int
        {
            return getTimer() - m_transitTime;
        }
        
        
        public function StateMachine( name: String ) 
        {
            m_name = name;
        }
       
        public function AddState( stateName: String ) : State
        {
            if ( null != m_states[ stateName ] )
            {
                throw Error( "In state machine " + m_name + ", state " + stateName + " already existed" );
            }
            
            var newState: State = new State( stateName );
            m_states[ stateName ] = newState;
            return newState;
        }
        
        public function StartAt( stateName: String ) : void
        {
            if ( null != m_currentState )
            {
                throw Error( "State machine " + m_name + " already started" );
            }

            m_currentState = this.FindState( stateName );
            m_transitTime = getTimer();
        }

        public function PostEvent( eventName: String ) : void
        {
            m_events.push( eventName );
        }
        
        public function Transit( targetStateName: String ) : void
        {
            if ( !m_canTransit )
            {
                throw Error( "State machine " + m_name + " can't transit at this context" );
            }
            
            this.DoTransit( targetStateName, null )
        }
        
        public function DoTransit( targetStateName: String, transitAction: Function ) : void
        {
            var targetState: State = this.FindState( targetStateName );

            //transition.fromState.TryExitAction();
            
            if ( null != transitAction )
            {
                transitAction();
            }
            
            //transition.toState.TryEnterAction();

            m_currentState = targetState;
            m_transitTime = getTimer();
            
        }
        
        public function Run() : int
        {
            var count: int = 0;
            m_canTransit = true;

            while ( 0 < m_events.length )
            {
                var event: String = m_events.shift();

                var reaction: Reaction = m_currentState.FindReaction( event );
                
                if ( null == reaction ) { continue; }
                
                var transition: Transition = reaction as Transition;
                if ( null != transition )
                {
                    var targetStateName: String = transition.targetStateName;
                
                    this.DoTransit( targetStateName, transition.action );
                }
                else
                {
                    if ( null != reaction.action )
                    {
                        reaction.action();
                    }
                }

                ++ count;
            }
            
            m_canTransit = false;
            
            return count;
        }
        

        private function FindState( stateName: String ) : State
        {
            var state: State = m_states[ stateName ];
            if ( null == state )
            {
                throw Error( "In state machine " + m_name + ", state " + stateName + " not found" );
            }
            
            return state;
        }
    }

}