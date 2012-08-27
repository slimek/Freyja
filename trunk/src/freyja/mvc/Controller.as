package freyja.mvc 
{
    import flash.display.DisplayObject;
    import flash.display.Stage;
    import flash.events.Event;
    import flash.events.EventDispatcher;
    
    import freyja.mvc.Model;
    import freyja.mvc.IView;

    public class Controller extends EventDispatcher
    {
        private var m_flashStage: flash.display.Stage = null;
    
        private var m_activeModel: Model            = null;
        private var m_activeViews: Vector.< IView > = null;
        
        private var m_modelMap: Object = new Object;
        private var m_viewMap:  Object = new Object;
        
        public function Controller( stage: Stage )
        {
            m_flashStage = stage;
        }
        
        
        //
        // 登錄 Model 與 View
        //
        
        public function RegisterModel( modelName: String, model: Model ) : void
        {
            if ( undefined != m_modelMap[ modelName ] )
            {
                throw new ArgumentError( "Model name " + modelName + " is duplicate" );
            }
        
            m_modelMap[ modelName ] = model;
        }
        
        public function BindView( modelName: String, view: IView ) : void
        {
            var model: Model = this.FindModel( modelName );
            
            if ( undefined == m_viewMap[ modelName ] )
            {
                m_viewMap[ modelName ] = new Vector.< IView >;
            }
            
            m_viewMap[ modelName ].push( view );
            view.BindToModel( model );
            
            if ( m_activeModel === model )
            {
                this.ActivateView( view );
            }
        }
        
        /**
         * 將 View 由 Controller 的連結表中移除。
         */
        public function UnbindView( view: IView ) : void
        {
            // 1. 如果 View 正在動作中，要先停用（Deactivate）。
            // 2. 將 View 從對應的 list 上移除。
            
            var idx: int = m_activeViews.indexOf( view );
            if ( -1 != idx )
            {
                this.DeactivateView( view );
            }
            
            var found: Boolean = false;
            
            for each ( var views: Vector.< IView > in m_viewMap )
            {
                idx = views.indexOf( view );
                if ( -1 != idx )
                {
                    views.splice( idx, 1 );
                    found = true;
                    break;
                }
            }
            
            if ( !found )
            {
                throw Error( "View to unbind not found : " + view );
            }
        }
        
        private function ActivateView( view: IView ) : void
        {
            view.OnEnterFrame();  // 在啟用 view （加進顯示列表）之前，先將畫面更新到與 model 同步。
            view.OnActivated();
        }
        
        private function DeactivateView( view: IView ) : void
        {
            view.OnDeactivated();
        }
        
        
        //
        // 啟動時指定從哪個 model 開始
        //
        
        public function StartAt( modelName: String ) : void
        {
            var model: Model = this.FindModel( modelName );
            
            model.ShiftFromModel( null );  // 要求直接從這個 model 啟動
            
            this.SetActiveModel( modelName, model );

            m_flashStage.addEventListener( Event.ENTER_FRAME, OnEnterFrame );
        }
        
        
        //
        // 切換 Model
        //
        
        private function ShiftModel( modelName: String ) : void
        {
            var newModel: Model = this.FindModel( modelName );
            
            var oldModel: Model = m_activeModel;
            m_activeModel = newModel;
            newModel.ShiftFromModel( oldModel );
            
            this.SetActiveModel( modelName, newModel );
        }
        
        
        private function SetActiveModel( modelName: String, model: Model ) : void
        {
            for each ( var oldView: IView in m_activeViews )
            {
                oldView.OnDeactivated();
                m_flashStage.removeChild( oldView as DisplayObject );
            }
                
            m_activeModel = model;
            m_activeViews = m_viewMap[ modelName ];

            m_activeModel.MainLoop();  // 在啟動 Views 之前，先將 Model 狀態更新。

            for each ( var view: IView in m_activeViews )
            {
                this.ActivateView( view );
            }
        }
        

        private function FindModel( modelName: String ) : Model
        {
            var model: Model = m_modelMap[ modelName ];
            if ( null == model )
            {
                throw new ArgumentError( "Model name " + modelName + " not found" );
            }
            return model;
        }


        //
        // 事件處理
        //
        
        private function OnEnterFrame( e: Event ) : void
        {
            // 在每個 frame 開始之前，先檢查是否要更換 model
            
            var shiftModelName: String = m_activeModel.TakeShifting();
            if ( "" != shiftModelName )
            {
                this.ShiftModel( shiftModelName );
            }
        
            m_activeModel.MainLoop();
        
            for each ( var view: IView in m_activeViews )
            {
                view.OnEnterFrame();
            }
        }
    }

}