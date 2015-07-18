concommand.Add("dsplitter_test", function()

	--Make a window to hold the example
	local frame = vgui.Create("DFrame")
	frame:SetTitle("DSplitter Example 2")
	frame:SetSizable(true)
	frame:SetSize(640,480)
	frame:SetMinWidth(400)
	frame:SetMinHeight(350)
	frame:Center()
	frame:MakePopup()
	
	--Add a vertical dsplitter
	local split1 = frame:Add("DSplitter")
	split1:Dock(FILL)
	split1:SetSplitterThickness(4)
	split1:SetSplitterColor(Color(128,128,128))
	split1:SetStretchPanel(1)
	split1:SetFixedPanelMinSize(40)
	split1:SetFixedPanelMaxSize(250)
	split1:SetVertical()
	--Get its content panels
	local top,bottom = split1.Panel1,split1.Panel2
	
	--Add a horizontal dsplitter in the top half
	local split2 = top:Add("DSplitter")
	split2:Dock(FILL)
	split2:SetSplitterThickness(4)
	split2:SetSplitterColor(Color(128,128,128))
	split2:SetStretchPanel(2)
	split2:SetFixedPanelMinSize(100)
	split2:SetFixedPanelMaxSize(300)
	split2:SetHorizontal()
	--Get its content panels
	local left,right = split2.Panel1,split2.Panel2
	
	--Add another horizontal dsplitter in the right of the top half
	local split3 = right:Add("DSplitter")
	split3:Dock(FILL)
	split3:SetSplitterThickness(4)
	split3:SetSplitterColor(Color(128,128,128))
	split3:SetStretchPanel(2)
	split3:SetFixedPanelMinSize(100)
	split3:SetFixedPanelMaxSize(300)
	split3:SetHorizontal()
	--Get its content panels
	local middle,right = split3.Panel1,split3.Panel2
	
	-- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
	-- The dsplitters are all ready to go now and the rest is just example content
	-- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
	
	--DTree in the left side
	local tree1 = left:Add("DTree")
	tree1:Dock(FILL)
	tree1:Root():AddFolder("materials","materials","GAME",false,"*")
	
	--DTree in the middle
	local tree2 = middle:Add("DTree")
	tree2:Dock(FILL)
	
	--An image on the right
	local image1 = right:Add("DImage")
	image1:Dock(FILL)
	image1:SetImage("vgui/avatar_default")
	
	--Status bar down the bottom
	local statustxt = bottom:Add("DTextEntry")
	statustxt:Dock(FILL)
	statustxt:SetMultiline(true)
	statustxt:SetEditable(false)
	
	--Function to write to the status bar
	local function Log(str)
		statustxt:SetText( os.date("%Y/%m/%d %X",os.time())..": "..str.."\n"..statustxt:GetText() )
	end
	
	--Make stuff happen when we click in the trees
	tree1.OnNodeSelected = function(tree,node)
		if not IsValid(node) then return end
		local children = tree2:Root().ChildNodes
		if IsValid(children) then
			for _,child in pairs(children:GetChildren()) do
				child:Remove()
			end
		end
		local folderpath = node:GetFolder()
		local foldername = string.GetFileFromFilename(folderpath)
		Log("Viewing folder: "..folderpath)
		tree2:Root():AddFolder(foldername,folderpath,"GAME",true,"*.vmt"):SetExpanded(true)
	end
	tree2.OnNodeSelected = function(tree,node)
		if not IsValid(node) then return end
		local filename = node:GetFileName()
		if not filename then return end
		Log("Loading material: "..filename)
		image1:SetImage( filename:sub(11) ) --remove materials/ from the start of the filename
	end
	
	Log("Example loaded")

end)
