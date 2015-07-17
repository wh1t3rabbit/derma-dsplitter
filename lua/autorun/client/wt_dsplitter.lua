
do --DSplitter container

	--- DSplitter.
	-- A panel that contains two content panels with a bar between them for resizing.
	-- @author Whiterabbit facepunch.com/member.php?u=468356
	local PNL = {}
	
	function PNL:Init()
		self.Panel1 = self:Add("DPanel")
		self.Splitter = self:Add("DSplitterBar")
		self.Panel2 = self:Add("DPanel")
		self:SetPanelColor(color_white,1)
		self:SetPanelColor(color_white,2)
		self:SetSplitterColor(Color(128,128,128))
		self:SetSplitterThickness(4)
		self:SetStretchPanel(1)
		self:SetHorizontal()
	end
	
	--- Set which panel will expand when the container resizes.
	-- @param pnlnum Which panel will expand (1 or 2).
	function PNL:SetStretchPanel(pnlnum)
		self.StretchPanel = (pnlnum<=1) and 1 or 2
	end
	
	--- Set container to layout horizontally.
	function PNL:SetHorizontal()
		self:SetLayoutDir(false)
	end
	
	--- Set container to layout vertically.
	function PNL:SetVertical()
		self:SetLayoutDir(true)
	end
	
	--- Set container layout direction.
	-- @param isVert True to layout vertically, false to layout horizontally.
	function PNL:SetLayoutDir(isVert)
		self.IsVertical = isVert
		self.IsHorizontal = not self.IsVertical
		self.Splitter:SetIsTall(self.IsHorizontal)
		if self.IsVertical then
			if self.StretchPanel==1 then
				self.Panel1:Dock(FILL)
				self.Splitter:Dock(BOTTOM)
				self.Panel2:Dock(BOTTOM)
			else
				self.Panel1:Dock(TOP)
				self.Splitter:Dock(TOP)
				self.Panel2:Dock(FILL)
			end
		else
			if self.StretchPanel==1 then
				self.Panel1:Dock(FILL)
				self.Splitter:Dock(RIGHT)
				self.Panel2:Dock(RIGHT)
			else
				self.Panel1:Dock(LEFT)
				self.Splitter:Dock(LEFT)
				self.Panel2:Dock(FILL)
			end
		end
	end
	
	--- Set the size of the splitter bar.
	-- @param nWidth Size of the splitter bar.
	function PNL:SetSplitterThickness(nWidth)
		self.SplitterWidth = nWidth or 4
		self.Splitter:SetThickness(self.SplitterWidth)
	end
	
	--- Set the color of the splitter bar.
	-- @param color The color to apply.
	function PNL:SetSplitterColor(color)
		self.Splitter:SetBackgroundColor(color)
	end
	
	--- Set the background color of a content panel.
	-- @param color The color to apply.
	-- @param panel Which panel to set the color of (1 or 2).
	function PNL:SetPanelColor(color,panel)
		if panel<=1 then
			self.Panel1:SetBackgroundColor(color)
		else
			self.Panel2:SetBackgroundColor(color)
		end
	end
	
	--- Resize the panels when the splitter bar 'moves'.
	-- Called internally by the DSplitterBar:Think().
	-- @param nAmt Distance the bar tried to move.
	function PNL:ResizeEx(nAmt)
		if self.IsVertical then
			if self.StretchPanel==1 then
				local NewSize = self.Panel2:GetTall()+nAmt
				if NewSize<=1 then
					NewSize = 1
				end
				self.Panel2:SetTall( NewSize )
			else
				local NewSize = self.Panel1:GetTall()+nAmt
				if NewSize<=1 then
					NewSize = 1
				end
				self.Panel1:SetTall( NewSize )
			end
		elseif self.IsHorizontal then
			if self.StretchPanel==1 then
				local NewSize = self.Panel2:GetWide()+nAmt
				if NewSize<=1 then
					NewSize = 1
				end
				self.Panel2:SetWide( NewSize )
			else
				local NewSize = self.Panel1:GetWide()+nAmt
				if NewSize<=1 then
					NewSize = 1
				end
				self.Panel1:SetWide( NewSize )
			end
		end
	end
	
	vgui.Register("DSplitter",PNL,"DPanel")
end

do --DSplitter bar

	--- DSplitterBar.
	-- The bar between the two content panels inside a DSplitter.
	local PNL = {}
	
	function PNL:Init()
		self.IsTall = false
		self.Thickness = 4
	end
	
	function PNL:Paint(w,h)
		surface.SetDrawColor(self:GetBackgroundColor())
		self:DrawFilledRect()
	end
	
	--- Set the thickness of the splitter bar.
	-- @param nThick The thickness of the bar.
	function PNL:SetThickness(nThick)
		self.Thickness = nThick or 4
	end
	
	--- Set the orientation of the splitter bar.
	-- Called internally by DSplitter:SetLayoutDir().
	-- @param bTall True when the container is laid out horizontally.
	function PNL:SetIsTall(bTall)
		self.IsTall = bTall and true or false
		if self.IsTall then
			self:SetWide(self.Thickness)
		else
			self:SetTall(self.Thickness)
		end
	end
	
	function PNL:Think()
		if self.Sizing then
			local mousex,mousey = gui.MouseX(),gui.MouseY()
			local dx,dy = mousex-self.Sizing[1],mousey-self.Sizing[2]
			self:SetCursor( self.IsTall and "sizewe" or "sizens" )
			self:GetParent():ResizeEx(IsTall and dx or dy)
			self.Sizing[1],self.Sizing[2] = mousex,mousey
		elseif self.Hovered then
			self:SetCursor( self.IsTall and "sizewe" or "sizens" )
		end
		self:SetCursor("arrow")
	end
	
	function PNL:OnMousePressed()
		self.Sizing = { gui.MouseX(), gui.MouseY() }
		self:MouseCapture(true)
	end
	
	function PNL:OnMouseReleased()
		self.Sizing = nil
		self:MouseCapture(false)
	end
	
	vgui.Register("DSplitterBar",PNL,"DPanel")
end
