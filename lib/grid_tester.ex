defmodule GridMonitor.Tester do
  use GenServer
  require Logger
  @module 'GridMonitor.Tester'

  def start_link() do
    :os.cmd 'epmd -daemon'
    Node.start(get_name())
    Node.set_cookie(:marlon_cluster)
    GenServer.start_link(__MODULE__, [], name: :tester)
  end

  def add_node do
    GenServer.cast(:tester, :add_node)
  end

  def update_node do
    GenServer.cast(:tester, :update_node)
  end

  def remove_node do
    GenServer.cast(:tester, :remove_node)
  end

  @impl true
  def init(_args) do
    Logger.debug("#{@module}.init")
    {:ok, []}
  end

  @impl true
  def handle_cast(:add_node, state) do
    Logger.debug("#{@module}.add_node")
    broker = { :broker, :'grid_broker@169.254.195.175'}
    data = %{id: 2, tmin: 19, tmax: 23, insulation: 500.0, powerUsage: 2000, troomData: [19.0], tambientData: [8.5], hpData: [300], ehpData: [200]}
    GenServer.cast(broker, {:add_node, data})
    data = %{id: 3, tmin: 20, tmax: 23, insulation: 25.0, powerUsage: 2080, troomData: [19.0], tambientData: [8.5], hpData: [300], ehpData: [200]}
    GenServer.cast(broker, {:add_node, data})


    {:noreply, state}
  end

  @impl true
  def handle_cast(:update_node, state) do
    Logger.debug("#{@module}.update_node")
    broker = { :broker, :'grid_broker@169.254.195.175'}
    data = %{id: 2,  powerUsage: 2500, troom: 20, tambient: 18, hp: 350, ehp: 250}
    GenServer.cast(broker, {:update_node, data})
    data = %{id: 2,  powerUsage: 2550, troom: 18, tambient: 19, hp: 380, ehp: 280}
    GenServer.cast(broker, {:update_node, data})


    {:noreply, state}
  end

  def handle_cast(:remove_node, state) do
    Logger.debug("#{@module}.remove_node")
    broker = { :broker, :'grid_broker@169.254.195.175'}
    data = %{id: 2}
    GenServer.cast(broker, {:remove_node, data})

    {:noreply, state}
  end



  defp get_name do
    {:ok, [{ {n1, n2, n3, n4}, _ ,_} | _rest]} = :inet.getif()
    :"grid_tester@#{n1}.#{n2}.#{n3}.#{n4}"
  end

end
